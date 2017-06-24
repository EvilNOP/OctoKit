//
//  Event.swift
//  OctoKit
//
//  Created by Matthew on 11/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

/// A class cluster for GitHub events.
public class Event: RealmSwift.Object, StaticMappable {
    
    // MARK: - Instance Properties
    
    /// The type of event.
    public internal(set) dynamic var type: String?
    
    /// The name of the repository upon which the event occurred (e.g., `github/Mac`).
    public internal(set) dynamic var repositoryName: String?
    
    /// The login of the user who instigated the event.
    public internal(set) dynamic var actorLogin: String?
    
    /// The URL for the avatar of the user who instigated the event.
    public internal(set) dynamic var actorAvatarURLString: String?
    
    /// The organization related to the event.
    public internal(set) dynamic var organizationLogin: String?
    
    /// The date that this event occurred.
    public internal(set) dynamic var date: Date?
    
    // MARK: - Lifecycle
    
    public class func objectForMapping(map: Map) -> BaseMappable? {
        func eventMaker(eventType: EventType) -> BaseMappable {
            switch eventType {
            case .CommitCommentEvent:
                return CommitCommentEvent()
            case .CreateEvent:
                return RefEvent()
            case .DeleteEvent:
                return RefEvent()
            case .ForkEvent:
                return ForkEvent()
            case .IssueCommentEvent:
                return IssueCommentEvent()
            case .IssuesEvent:
                return IssueEvent()
            case .MemberEvent:
                return MemberEvent()
            case .PublicEvent:
                return PublicEvent()
            case .PullRequestEvent:
                return PullRequestEvent()
            case .PullRequestCommentEvent:
                return PullRequestCommentEvent()
            case .PushEvent:
                return PushEvent()
            case .WatchEvent:
                return WatchEvent()
            }
        }
        
        if let typeString = map.JSON["type"] as? String, let eventType = EventType(rawValue: typeString) {
            return eventMaker(eventType: eventType)
        } else if let eventType = map.JSON["type"] as? EventType {
            return eventMaker(eventType: eventType)
        }
        
        return nil
    }
    
    // MARK: - Mapping
    
    public func mapping(map: Map) {
//        let transform = TransformOf<EventType, String>(fromJSON: { value in
//            guard let typeString = value else {
//                return nil
//            }
//            
//            return EventType(rawValue: typeString)
//        }, toJSON: { value in
//            guard let eventType = value else {
//                return nil
//            }
//            
//            return eventType.rawValue
//        })
        
        type                 <- map["type"]
        repositoryName       <- map["repo.name"]
        actorLogin           <- map["actor.login"]
        actorAvatarURLString <- map["actor.avatar_url"]
        organizationLogin    <- map["org.login"]
        date                 <- (map["created_at"], ISO8601DateTransform())
    }
    
    // MARK: - Custom String Convertible
    
    public override var description: String {
        guard let description = toJSONString(prettyPrint: true) else {
            return ""
        }
        
        return description
    }
}

