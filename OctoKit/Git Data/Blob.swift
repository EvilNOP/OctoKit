//
//  Blob.swift
//  OctoKit
//
//  Created by Matthew on 20/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A git blob.
public class Blob: Object {
    
    // MARK: - Instance Properties
    
    /// The content of the blob.
    public internal(set) dynamic var content: String?
    
    /// The encoding of content of the blob.
    public internal (set) dynamic var encoding: String?
    
    /// The URL for the tree.
    public internal(set) dynamic var URLString: String?
    
    /// The SHA of the blob.
    public internal(set) dynamic var SHA: String?
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        content   <- map["content"]
        encoding  <- map["encoding"]
        URLString <- map["url"]
        SHA       <- map["sha"]
    }
}
