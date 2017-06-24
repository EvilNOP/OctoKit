//
//  CommitComment.swift
//  OctoKit
//
//  Created by Matthew on 30/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A single comment on a commit.
public class CommitComment: Object, ReviewComment {
    
    // MARK: - Instance Properties
    
    /// The webpage URL for this comment.
    public internal(set) dynamic var HTMLURLString: String?
    
    // MARK: - ReviewComment
    
    public internal(set) dynamic var path: String?
    
    public internal(set) dynamic var commitSHA: String?
    
    public internal(set) dynamic var position: Int = 0
    
    // MARK: - Comment
    
    public internal(set) dynamic var commenterLogin: String?
    
    public internal(set) dynamic var creationDate: Date?
    
    public internal(set) dynamic var updatedDate: Date?
    
    public internal(set) dynamic var body: String?
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        let dateTransform = ISO8601DateTransform()
        
        HTMLURLString  <- map["html_url"]
        commitSHA      <- map["commit_id"]
        commenterLogin <- map["user.login"]
        creationDate   <- (map["created_at"], dateTransform)
        updatedDate    <- (map["updated_at"], dateTransform)
    }
}
