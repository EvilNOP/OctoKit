//
//  PullRequestEvent.swift
//  OctoKit
//
//  Created by Matthew on 16/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A pull request was opened or closed or somethin'.
public class PullRequestEvent: Event {
    
    // MARK: - Instance Properties
    
    /// The pull request number.
    public private(set) dynamic var number: Int = 0
    
    /// The pull request being modified.
    public internal(set) dynamic var pullRequest: PullRequest?
    
    /// The action that took place upon the pull request.
    public internal(set) dynamic var action: String?
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
//        let transform = TransformOf<IssueAction, String>(fromJSON: { value in
//            guard let actionString = value else {
//                return nil
//            }
//            
//            return IssueAction(rawValue: actionString)
//        }, toJSON: { value in
//            guard let action = value else {
//                return nil
//            }
//            
//            return action.rawValue
//        })
        
        number      <- map["number"]
        pullRequest <- map["payload.pull_request"]
        action      <- map["payload.action"]
    }
}
