//
//  TreeEntryMode.swift
//  OctoKit
//
//  Created by Matthew on 20/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

/// The file mode of the entry.
public enum TreeEntryMode: String {
    
    /// File (blob) mode.
    case file
    
    /// Executable (blob) mode.
    case executable
    
    /// Subdirectory (tree) mode.
    case subdirectory
    
    /// Submodule (commit) mode.
    case submodule
    
    /// Blob which specifies the path of a symlink.
    case symlink
}
