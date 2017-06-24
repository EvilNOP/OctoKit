//
//  Branch.swift
//  OctoKit
//
//  Created by Matthew on 15/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

// A GithHub repository branch.
public class Branch: Object {
    
    // MARK: - Instance Properties
    
    /// The name of the branch.
    public internal(set) dynamic var name: String?
    
    /// The SHA of the last commit on this branch.
    public internal(set) dynamic var lastCommitSHA: String?
    
    /// The API URL to the last commit on this branch.
    public internal(set) dynamic var lastCommitURLString: String?
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        name                <- map["name"]
        lastCommitSHA       <- map["commit.sha"]
        lastCommitURLString <- map["commit.url"]
    }
}
