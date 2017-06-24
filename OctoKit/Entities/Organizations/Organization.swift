//
//  Organization.swift
//  OctoKit
//
//  Created by Matthew on 25/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

/// An organization.
public class Organization: Entity {
    
    /// The Teams in this organization.
    ///
    /// Client endpoints do not actually set this property. It is provided as
    /// a convenience for persistence and model merging.
    let teams = List<Team>()
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
}
