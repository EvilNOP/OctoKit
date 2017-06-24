//
//  PublicKey.swift
//  OctoKit
//
//  Created by Matthew on 26/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

// A public SSH key.
public class PublicKey: Object {
    
    /// The name given to this key by the user.
    public internal(set) dynamic var title: String?
    
    /// The public key data itself.
    public internal(set) dynamic var publicKey: String?
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        title     <- map["title"]
        publicKey <- map["key"]
    }
}
