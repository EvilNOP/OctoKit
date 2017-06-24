//
//  IssueCommentEvent.swift
//  OctoKit
//
//  Created by Matthew on 16/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A user commented on an issue.
public class IssueCommentEvent: Event {
    
    // MARK: - Instance Properties
    
    /// The comment that was posted.
    public internal(set) dynamic var comment: IssueComment?
    
    /// The issue upon which the comment was posted.
    public internal(set) dynamic var issue: Issue?
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        comment <- map["payload.comment"]
        issue   <- map["payload.issue"]
    }
}
