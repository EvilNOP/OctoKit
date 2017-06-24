//
//  PullRequestState.swift
//  OctoKit
//
//  Created by Matthew on 20/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

/// The state of the pull request, open or closed.
public enum PullRequestState: String {
    
    /// The pull request is open.
    case open
    
    /// The pull request is closed.
    case closed
}
