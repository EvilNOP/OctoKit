//
//  AccessToken.swift
//  OctoKit
//
//  Created by Matthew on 06/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// An OAuth access token returned from the web flow.
public class AccessToken: Object {
    
    // MARK: - Instance Properties
    
    /// The access token itself. You should treat this as you would the user's
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
        
        token <- map["access_token"]
    }
}
