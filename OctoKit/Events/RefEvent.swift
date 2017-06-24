//
//  RefEvent.swift
//  OctoKit
//
//  Created by Matthew on 16/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A git reference (branch or tag) was created or deleted.
public class RefEvent: Event {
    
    // MARK: - Instance Properties
    
    /// The kind of reference that was created or deleted.
    public internal(set) dynamic var refType: String?
    
    /// The type of event that occurred with the reference.
    public internal(set) dynamic var eventType: String?
    
    /// The short name of this reference (e.g., "master").
    public internal(set) dynamic var refName: String?
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
//        let refTypeTransform = TransformOf<RefType, String>(fromJSON: { value in
//            guard let refTypeString = value else {
//                return nil
//            }
//            
//            return RefType(rawValue: refTypeString)
//        }, toJSON: { value in
//            guard let refType = value else {
//                return nil
//            }
//            
//            return refType.rawValue
//        })
//        
//        let eventTypeTransform = TransformOf<RefEventType, String>(fromJSON: { value in
//            guard let refEventTypeString = value else {
//                return nil
//            }
//            
//            return RefEventType(rawValue: refEventTypeString)
//        }, toJSON: { value in
//            guard let refEventType = value else {
//                return nil
//            }
//            
//            return refEventType.rawValue
//        })
        
        eventType <- map["type"]
        refType   <- map["payload.ref_type"]
        refName   <- map["payload.ref"]
    }
}
