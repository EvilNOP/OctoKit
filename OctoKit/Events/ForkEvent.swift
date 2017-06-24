//
//  ForkEvent.swift
//  OctoKit
//
//  Created by Matthew on 16/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A user forked a repository.
public class ForkEvent: Event {
    
    // MARK: - Instance Properties
    
    /// The name of the repository created by forking (e.g., `user/Mac`).
    public internal(set) dynamic var forkedRepositoryName: String?
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        forkedRepositoryName <- map["payload.forkee.full_name"]
    }
}
