//
//  PullRequest.swift
//  OctoKit
//
//  Created by Matthew on 29/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

// A pull request on a repository.
public class PullRequest: Object {
    
    // MARK: - Instance Properties
    
    /// The api URL for this pull request.
    public internal(set) dynamic  var URLString: String?
    
    /// The webpage URL for this pull request.
    public internal(set) dynamic var HTMLURLString: String?
    
    /// The diff URL for this pull request.
    public internal(set) dynamic var diffURLString: String?
    
    /// The patch URL for this pull request.
    public internal(set) dynamic var patchURLString: String?
    
    /// The issue URL for this pull request.
    public internal(set) dynamic var issueURLString: String?
    
    /// The user that opened this pull request.
    public internal(set) dynamic var user: User?
    
    /// The title of this pull request.
    public internal(set) dynamic var title: String?
    
    /// The body text for this pull request.
    public internal(set) dynamic var body: String?
    
    /// The user this pull request is assigned to.
    public internal(set) dynamic var assignee: User?
    
    /// The date/time this pull request was created.
    public internal(set) dynamic var creationDate: Date?
    
    /// The date/time this pull request was last updated.
    public internal(set) dynamic var updatedDate: Date?
    
    /// The date/time this pull request was closed. nil if the
    /// pull request has not been closed.
    public internal(set) dynamic var closedDate: Date?
    
    /// The date/time this pull request was merged. nil if the
    /// pull request has not been merged.
    public internal(set) dynamic var mergedDate: Date?
    
    /// The state of this pull request.
    public internal(set) dynamic var state: String?
    
    /// The repository that contains the pull request's changes.
    public internal(set) dynamic var headRepository: Repository?
    
    /// The repository that the pull request's changes should be pulled into.
    public internal(set) dynamic var baseRepository: Repository?
    
    /// The name of the branch which contains the pull request's changes.
    public internal(set) dynamic var headBranch: String?
    
    /// The name of the branch into which the changes will be merged.
    public internal(set) dynamic var baseBranch: String?
    
    /// The number of commits included in this pull request.
    public internal(set) dynamic var commits: Int = 0
    
    /// The number of additions included in this pull request.
    public internal(set) dynamic var additions: Int = 0
    
    /// The number of deletions included in this pull request.
    public internal(set) dynamic var deletions: Int = 0
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        let dateTransform = ISO8601DateTransform()
        
//        let transform = TransformOf<PullRequestState, String>(fromJSON: { value in
//            guard let stateString = value else {
//                return nil
//            }
//            
//            return PullRequestState(rawValue: stateString)
//        }, toJSON: { value in
//            guard let state = value else {
//                return nil
//            }
//            
//            return state.rawValue
//        })
        
        id             <- map["number"]
        headRepository <- map["head.repo"]
        baseRepository <- map["base.repo"]
        headBranch     <- map["head.ref"]
        baseBranch     <- map["base.ref"]
        title          <- map["title"]
        body           <- map["body"]
        state          <- map["state"]
        assignee       <- map["assignee"]
        commits        <- map["commits"]
        additions      <- map["additions"]
        deletions      <- map["deletions"]
        URLString      <- map["url"]
        HTMLURLString  <- map["html_url"]
        diffURLString  <- map["diff_url"]
        patchURLString <- map["patch_url"]
        issueURLString <- map["issue_url"]
        creationDate   <- (map["created_at"], dateTransform)
        updatedDate    <- (map["updated_at"], dateTransform)
        closedDate     <- (map["closed_at"], dateTransform)
        mergedDate     <- (map["created_at"], dateTransform)
    }
}
