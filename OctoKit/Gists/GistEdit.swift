//
//  GistEdit.swift
//  OctoKit
//
//  Created by Matthew on 12/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

// Changes to a gist, or a new gist.
public class GistEdit: Mappable {
    
    // MARK: - Instance Properties
    
    /// The unique ID for this object.
    public internal(set) var id: String
    
    /// If not nil, the new description to set for the gist.
    public internal(set) var gistDescription: String?
    
    /// Files to modify, represented as GistFileEdits keyed by filename.
    public internal(set) var filesToModify: [String : GistFileEdit]?
    
    /// Files to add, represented as GistFileEdits.
    ///
    /// Each edit must have a `filename` and `content`.
    public internal(set) var filesToAdd: [GistFileEdit]?
    
    /// The names of files to delete.
    public internal(set) var filenamesToDelete: [String]?
    
    /// Whether this gist should be public.
    public internal(set) var isPublic: Bool?
    
    private var fileChangesBackingValue: [String : GistFileEdit]?
    
    // MARK: - Computed Properties
    
    /// A combination of the information in `filesToModify`, `filesToAdd`, and
    /// `filenamesToDelete`, used for easy JSON serialization.
    ///
    /// This dictionary contains GistFileEdits keyed by filename. Deleted
    /// filenames will have an NSNull value.
    private var fileChanges: [String : Any]? {
        get {
            var edits: [String : Any] = filesToModify ?? [:]
            
            if filesToAdd != nil {
                for edit in filesToAdd! where edit.filename != nil && edit.content != nil {
                    edits[edit.filename!] = edit
                }
            }
            
            if filenamesToDelete != nil {
                for filename in filenamesToDelete! {
                    edits[filename] = NSNull()
                }
            }
            
            return edits
        }
        
        set(newFileChanges) {
            fileChangesBackingValue = (newFileChanges as? [String : GistFileEdit])
        }
    }
    
    // MARK: - Lifecycle
    
    public init(filesToModify: [String : GistFileEdit]?, filesToAdd: [GistFileEdit]?,
                filenamesToDelete: [String]?, description: String? = nil, isPublic: Bool? = nil) {
        self.id = ""
        self.filesToModify = filesToModify
        self.filesToAdd = filesToAdd
        self.filenamesToDelete = filenamesToDelete
        self.gistDescription = description
        self.isPublic = isPublic
    }
    
    public required init?(map: Map) {
        return nil
    }
    
    // MARK: - Mapping
    
    public func mapping(map: Map) {
        let transform = TransformOf<[String : Any], [String : Any]>(fromJSON: { value in
            guard let filesJSON = value else {
                return nil
            }
            
            var fileChanges: [String : Any] = [ : ]
            
//          We have JSON like:
//            "files": {
//                "ring.erl": {
//                    "size": 932,
//                    "raw_url": "https://gist.githubusercontent.com/raw/365370/8c4d2d43d178df44f4c03a7f2ac0ff512853564e/ring.erl",
//                    "type": "text/plain",
//                    "language": "Erlang",
//                    "truncated": false,
//                    "content": "contents of gist"
//                }
//            }
//          The following loop convert JSON to `[String : GistFileEdit]`.
            for (filename, editJSON) in filesJSON {
                if let editJSON = editJSON as? [String : Any], let edit = GistFileEdit(JSON: editJSON) {
                    fileChanges[filename] = edit
                }
            }
            
            return fileChanges
        }, toJSON: { value in
            guard let fileChanges = value else {
                return nil
            }
            
            var filesJSON: [String : Any] = [ : ]
            
//          The following loop convert `[String : Any]` to JSON like:
//            {
//                "file1.txt": {
//                    "content": "updated file contents"
//                },
//                "old_name.txt": {
//                    "filename": "new_name.txt",
//                    "content": "modified contents"
//                },
//                "new_file.txt": {
//                    "content": "a new file"
//                },
//                "delete_this_file.txt": null
//            }
            for (filename, edit) in fileChanges {
                if edit is NSNull {
                    filesJSON[filename] = NSNull()
                } else if let edit = edit as? GistFileEdit {
                    filesJSON[filename] = edit.toJSON()
                }
            }
            
            return filesJSON
        })
        
        gistDescription <- map["description"]
        fileChanges     <- (map["files"], transform)
        isPublic        <- map["public"]
    }
}

// MARK: - Custom String Convertible
extension GistEdit: CustomStringConvertible {
    
    public var description: String {
        return toJSONString(prettyPrint: true) ?? ""
    }
}
