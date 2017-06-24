//
//  Issue.swift
//  OctoKit
//
//  Created by Matthew on 01/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// An issue on a repository.
public class Issue: Object {
    
    // MARK: - Instance Properties
    
    /// The URL for this issue.
    public private(set) dynamic var URLString: String?
    
    /// The webpage URL for this issue.
    public private(set) dynamic var HTMLURLString: String?
    
    /// The title of this issue.
    public private(set) dynamic var title: String?
    
    /// The pull request that is attached to (i.e., the same as) this issue, or nil
    /// if this issue does not have code attached.
    public private(set) dynamic var pullRequest: PullRequest?
    
    /// The state of the issue.
    public private(set) dynamic var state: String?
    
    /// The issue number.
    public private(set) dynamic var number: Int = 0
    
    /// The webpage URL for any attached pull request.
    public private(set) dynamic var pullRequestHTMLURLString: String?
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
//        let transform = TransformOf<IssueState, String>(fromJSON: { value in
//            guard let stateString = value else {
//                return nil
//            }
//            
//            return IssueState(rawValue: stateString)
//        }, toJSON: { value in
//            guard let state = value else {
//                return nil
//            }
//            
//            return state.rawValue
//        })
        
        title                    <- map["title"]
        number                   <- map["number"]
        state                    <- map["state"]
        pullRequest              <- map["pull_request"]
        URLString                <- map["url"]
        HTMLURLString            <- map["html_url"]
        pullRequestHTMLURLString <- map["pull_request.html_url"]
    }
}
