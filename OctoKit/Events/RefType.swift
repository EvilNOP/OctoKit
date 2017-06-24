//
//  RefType.swift
//  OctoKit
//
//  Created by Matthew on 20/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

/// Represents the type of a git reference.
public enum RefType: String {
    
    /// An unknown type of reference. Ref events will never
    /// be initialized with this value they will simply
    /// fail to be created.
    case unknown
    
    /// A repository.
    case repository
    
    /// A branch in a repository.
    case branch
    
    /// A tag in a repository.
    case tag
}
