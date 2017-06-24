//
//  NotificationType.swift
//  OctoKit
//
//  Created by Matthew on 20/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

/// The type of the notification.
public enum NotificationType: String {
    
    /// An unknown type of notification.
    case unknown
    
    /// A new issue, or a new comment on one.
    case issue
    
    /// A new pull request, or a new comment on one.
    case pullRequest
    
    /// A new comment on a commit.
    case commit
}
