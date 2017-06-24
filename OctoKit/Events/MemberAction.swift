//
//  MemberAction.swift
//  OctoKit
//
//  Created by Matthew on 20/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

/// The type of action performed.
public enum MemberAction: String {
    
    /// An unknown action occurred.
    /// Member events will never be initialized with this value
    /// they will simply fail to be created.
    case unknown
    
    /// The user was added as a collaborator to the repository.
    case added
}
