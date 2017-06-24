//
//  PullRequestCommentEvent.swift
//  OctoKit
//
//  Created by Matthew on 16/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A user commented on a pull request.
public class PullRequestCommentEvent: Event {
    
    // MARK: - Instance Properties
    
    /// The comment that was posted.
    public internal(set) dynamic var comment: PullRequestComment?
    
    /// The pull request upon which the comment was posted.
    ///
    /// This is not set by the events API. It must be fetched and explicitly set in
    /// order to be used.
    public internal(set) dynamic var pullRequest: PullRequest?
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        comment      <- map["payload.comment"]
        pullRequest  <- map["pull_request"]
    }
}
