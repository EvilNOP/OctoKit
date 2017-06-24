//
//  SubmoduleContent.swift
//  OctoKit
//
//  Created by Matthew on 26/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A submodule in a git repository.
public class SubmoduleContent: Content {
    
    // MARK: - Instance Properties
    
    /// The git URL of the submodule.
    public internal(set) dynamic var submoduleGitURLString: String?
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        submoduleGitURLString <- map["submodule_git_url"]
    }
}
