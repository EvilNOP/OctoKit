//
//  Plan.swift
//  OctoKit
//
//  Created by Matthew on 28/12/2016.
//  Copyright © 2016 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

public class Plan: Object {
    
    // MARK: - Instance Properties
    
    /// The name of this plan.
    public internal(set) dynamic var name: String?
    
    /// The number of collaborators allowed by this plan.
    public internal(set) dynamic var collaborators: Int = 0
    
    /// The number of kilobytes of disk space allowed by this plan.
    public internal(set) dynamic var space: Int = 0
    
    /// The number of private repositories allowed by this plan.
    public internal(set) dynamic var privateRepos: Int = 0
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        name          <- map["name"]
        collaborators <- map["collaborators"]
        space         <- map["space"]
        privateRepos  <- map["private_repos"]
    }
}

