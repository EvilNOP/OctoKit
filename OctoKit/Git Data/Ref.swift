//
//  Ref.swift
//  OctoKit
//
//  Created by Matthew on 19/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A git reference.
public class Ref: Object {
    
    // MARK: - Instance Properties
    
    /// The fully qualified name of this reference.
    public internal(set) dynamic var name: String?
    
    /// The SHA of the git object that this ref points to.
    public internal(set) dynamic var SHA: String?
    
    /// The API URL to the git object that this ref points to.
    public internal(set) dynamic var objectURLString: String?
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        name            <- map["ref"]
        SHA             <- map["object.sha"]
        objectURLString <- map["object.url"]
    }
}
