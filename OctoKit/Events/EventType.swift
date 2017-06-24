//
//  EventType.swift
//  OctoKit
//
//  Created by Matthew on 20/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

/// The type of content in a repository.
public enum EventType: String {
    
    case CommitCommentEvent
    
    case CreateEvent
    
    case DeleteEvent
    
    case ForkEvent
    
    case IssueCommentEvent
    
    case IssuesEvent
    
    case MemberEvent
    
    case PublicEvent
    
    case PullRequestEvent
    
    case PullRequestCommentEvent
    
    case PushEvent
    
    case WatchEvent
}
