//
//  MemberEvent.swift
//  OctoKit
//
//  Created by Matthew on 16/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A user commented on a commit.
public class MemberEvent: Event {
    
    // MARK: - Instance Properties
    
    /// The login of the user that was added to the repository.
    public internal(set) dynamic var memberLogin: String?
    
    /// The action that took place.
    public internal(set) dynamic var action: String?
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
//        let transform = TransformOf<MemberAction, String>(fromJSON: { value in
//            guard let memberString = value else {
//                return nil
//            }
//            
//            return MemberAction(rawValue: memberString)
//        }, toJSON: { value in
//            guard let action = value else {
//                return nil
//            }
//            
//            return action.rawValue
//        })

        memberLogin <- map["payload.member.login"]
        action      <- map["payload.action"]
    }
}
