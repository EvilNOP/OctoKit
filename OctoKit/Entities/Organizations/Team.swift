//
//  Team.swift
//  OctoKit
//
//  Created by Matthew on 25/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// Represents a team within an Organization.
public class Team: Entity {
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
}
