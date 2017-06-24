//
//  SymlinkContent.swift
//  OctoKit
//
//  Created by Matthew on 26/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A symlink in a git repository.
public class SymlinkContent: Content {
    
    // MARK: - Instance Properties
    
    /// The path to the symlink target.
    public internal(set) dynamic var target: String?
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        target <- map["target"]
    }
}
