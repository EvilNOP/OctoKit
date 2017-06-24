//
//  IssueComment.swift
//  OctoKit
//
//  Created by Matthew on 01/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A single comment on an issue.
public class IssueComment: Object, Comment {
    
    // MARK: - Instance Properties
    
    /// The webpage URL for this comment.
    public internal(set) dynamic var HTMLURLString: String?
    
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
        commenterLogin <- map["user.login"]
        creationDate   <- (map["created_at"], dateTransform)
        updatedDate    <- (map["updated_at"], dateTransform)
    }
}
