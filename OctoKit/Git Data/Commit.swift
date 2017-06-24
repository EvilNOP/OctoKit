//
//  Commit.swift
//  OctoKit
//
//  Created by Matthew on 18/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

// A git commit.
public class Commit: Object {
    
    // MARK: - Instance Properties
    
    /// The SHA for this commit.
    public internal(set) dynamic var SHA: String?
    
    /// The API URL to the tree that this commit points to.
    public internal(set) dynamic var treeURLString: String?
    
    /// The SHA of the tree that this commit points to.
    public internal(set) dynamic var treeSHA: String?
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        SHA           <- map["sha"]
        treeURLString <- map["tree.url"]
        treeSHA       <- map["tree.sha"]
    }
}
