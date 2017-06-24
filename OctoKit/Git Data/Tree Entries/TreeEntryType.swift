//
//  TreeEntryType.swift
//  OctoKit
//
//  Created by Matthew on 20/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

/// The types of tree entries.
public enum TreeEntryType: String {
    
    /// A blob of data.
    case blob
    
    /// A tree of entries.
    case tree
    
    /// A commit.
    case commit
}
