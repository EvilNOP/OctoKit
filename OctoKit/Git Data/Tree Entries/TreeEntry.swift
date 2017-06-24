//
//  TreeEntry.swift
//  OctoKit
//
//  Created by Matthew on 19/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

/// A class cluster for git tree entries.
public class TreeEntry: RealmSwift.Object,  StaticMappable {
    
    // MARK: - Instance Properties
    
    /// The SHA of the entry.
    public internal(set) dynamic var SHA: String?
    
    /// The repository-relative path.
    public internal(set) dynamic var path: String?
    
    /// The type of the entry.
    public internal(set) dynamic var type: String?
    
    /// The mode of the entry.
    public internal(set) dynamic var mode: String?
    
    /// The URL for the entry.
    public internal(set) dynamic var URLString: String?
    
    // MARK: - Lifecycle
    
    public class func objectForMapping(map: Map) -> BaseMappable? {
        func treeEntryMaker(treeEntryType: TreeEntryType) -> BaseMappable {
            switch treeEntryType {
            case .blob:
                return BlobTreeEntry()
            case .tree:
                return ContentTreeEntry()
            case .commit:
                return CommitTreeEntry()
            }
        }
        
        if let typeString = map.JSON["type"] as? String,
           let treeEntryType = TreeEntryType(rawValue: typeString) {
            return treeEntryMaker(treeEntryType: treeEntryType)
        } else if let treeEntryType = map.JSON["type"] as? TreeEntryType {
            return treeEntryMaker(treeEntryType: treeEntryType)
        }
        
        return nil
    }
    
    // MARK: - Mapping
    
    public func mapping(map: Map) {
//        let typeTransform = TransformOf<TreeEntryType, String>(fromJSON: { value in
//            guard let typeString = value else {
//                return nil
//            }
//            
//            return TreeEntryType(rawValue: typeString)
//        }, toJSON: { value in
//            guard let treeEntryType = value else {
//                return nil
//            }
//            
//            return treeEntryType.rawValue
//        })
//        
//        let modeByModeCode: [String : TreeEntryMode] = [
//            "100644" : .file,
//            "100755" : .executable,
//            "040000" : .subdirectory,
//            "160000" : .submodule,
//            "120000" : .symlink
//        ]
//        
//        let modeCodeByMode: [TreeEntryMode : String] = [
//            .file         : "100644",
//            .executable   : "100755",
//            .subdirectory : "040000",
//            .submodule    : "160000",
//            .symlink      : "120000"
//        ]
//        
//        let modeTransform = TransformOf<TreeEntryMode, String>(fromJSON: { value in
//            guard let modeCode = value else {
//                return nil
//            }
//            
//            return modeByModeCode[modeCode]
//        }, toJSON: { value in
//            guard let treeEntryMode = value else {
//                return nil
//            }
//            
//            return modeCodeByMode[treeEntryMode]
//        })
        
        SHA       <- map["sha"]
        path      <- map["path"]
        URLString <- map["url"]
        type      <- map["type"]
        mode      <- map["mode"]
    }
    
    // MARK: - Custom String Convertible
    
    public override var description: String {
        return toJSONString(prettyPrint: true) ?? ""
    }
}
