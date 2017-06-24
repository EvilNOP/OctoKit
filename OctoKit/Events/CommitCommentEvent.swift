//
//  CommitCommentEvent.swift
//  OctoKit
//
//  Created by Matthew on 16/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A user commented on a commit.
public class CommitCommentEvent: Event {
    
    // MARK: - Instance Properties
    
    /// The comment that was posted.
    public internal(set) dynamic var comment: CommitComment?
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        comment <- map["comment"]
    }
}
