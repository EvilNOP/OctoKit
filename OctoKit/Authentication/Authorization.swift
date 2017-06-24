//
//  Authorization.swift
//  OctoKit
//
//  Created by Matthew on 06/03/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

public class Authorization: Object {
    
    // MARK: - Instance Properties
    
    /// The authorization token. You should treat this as you would the user's
    /// password.
    ///
    /// This property will not be serialized to JSON. If you need to persist it, save
    /// it to the Keychain.
    public internal(set) dynamic var token: String?
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        token <- map["token"]
    }
}
