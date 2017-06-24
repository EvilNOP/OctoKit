//
//  IssueAction.swift
//  OctoKit
//
//  Created by Matthew on 20/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

/// The type of action performed on an issue or pull request.
public enum IssueAction: String {
    
    /// An unknown action occurred. Issue events will never be initialized with this value
    /// they will simply fail to be created.
    case unknown
    
    /// The issue or pull request was opened.
    case opened
    
    /// The issue or pull request was closed.
    case closed
    
    /// The issue or pull request was reopened.
    case reopened
}
