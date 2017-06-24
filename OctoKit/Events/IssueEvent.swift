//
//  IssueEvent.swift
//  OctoKit
//
//  Created by Matthew on 16/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

// An issue was opened or closed or somethin'.
public class IssueEvent: Event {
    
    // MARK: - Instance Properties
    
    /// The issue being modified.
    public internal(set) dynamic var issue: Issue?
    
    // The action that took place upon the issue.
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
        
        issue  <- map["payload.issue"]
        action <- map["payload.action"]
    }
}
