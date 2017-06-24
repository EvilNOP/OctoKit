//
//  Gist.swift
//  OctoKit
//
//  Created by Matthew on 28/12/2016.
//  Copyright © 2016 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

// A gist.
public class Gist: Object {
    
    // MARK: - Instance Properties
    
    /// The unique ID for this gist.
    public internal(set) dynamic var gistID: String?
    
    /// The login of the account which owns this repository.
    ///
    /// This is the first half of a unique GitHub repository name, which follows the
    /// form `ownerLogin/name`.
    public internal(set) dynamic var ownerLogin: String?
    
    /// The description of this gist.
    public internal(set) dynamic var gistDescription: String?
    
    /// The number of comments for this gist.
    public internal(set) dynamic var comments: Int = 0
    
    /// The date at which the gist was originally created.
    public internal(set) dynamic var creationDate: Date?
    
    /// The last updated date of this gist.
    public internal(set) dynamic var updatedDate: Date?
    
    /// The webpage URL for this gist.
    public internal(set) dynamic var HTMLURLString: String?
    
    /// The GistFiles in the gist, keyed by filename.
    private var filesBackingValue: [String : GistFile]?
    
    // MARK: - Computed Properties
    
    public var files: [GistFile]? {
        if filesBackingValue != nil {
            return Array(filesBackingValue!.values)
        }
        
        return nil
    }
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - PrimaryKey
    
    static public override func primaryKey() -> String? {
        return "gistID"
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        let dateTransform = ISO8601DateTransform()
        
        gistID            <- map["id"]
        ownerLogin        <- map["owner.login"]
        gistDescription   <- map["description"]
        comments          <- map["comments"]
        creationDate      <- (map["created_at"], dateTransform)
        updatedDate       <- (map["updated_at"], dateTransform)
        HTMLURLString     <- map["html_url"]
        filesBackingValue <- map["files"]
    }
}
