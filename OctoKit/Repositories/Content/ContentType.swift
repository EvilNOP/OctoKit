//
//  ContentType.swift
//  OctoKit
//
//  Created by Matthew on 20/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

/// The type of content in a repository.
public enum ContentType: String {
    
    /// The content is a file.
    case file
    
    /// The content is a directory.
    case dir
    
    /// The content is a symlink.
    case symlink
    
    /// The content is a submodule.
    case submodule
}
