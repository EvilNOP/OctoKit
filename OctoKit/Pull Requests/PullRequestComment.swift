//
//  PullRequestComment.swift
//  OctoKit
//
//  Created by Matthew on 17/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

// A single comment on a pull request.
public class PullRequestComment: IssueComment, ReviewComment {
    
    // MARK: - Instance Properties
    
    /// The API URL for the pull request upon which this comment appears.
    public internal(set) var pullRequestAPIURLString: String?
    
    /// The HEAD SHA of the pull request when the comment was originally made.
    public internal(set) var originalCommitSHA: String?
    
    /// This is the line index into the pull request's diff when the
    /// comment was originally made.
    public internal(set) var originalPosition: Int = 0
    
    /// The hunk in the diff that this comment originally refered to.
    public internal(set) var diffHunk: String?
    
    // MARK: - Review Comment
    
    public internal(set) var path: String?
    
    public internal(set) var commitSHA: String?
    
    public internal(set) var position: Int = 0
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        commenterLogin          <- map["user.login"]
        pullRequestAPIURLString <- map["_links.pull_request.href"]
        originalCommitSHA       <- map["original_commit_id"]
        originalPosition        <- map["original_position"]
        diffHunk                <- map["diff_hunk"]
        path                    <- map["path"]
        commitSHA               <- map["commit_id"]
        position                <- map["position"]
    }
}
