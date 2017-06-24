//
//  BlobTreeEntry.swift
//  OctoKit
//
//  Created by Matthew on 19/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A blob tree entry.
public class BlobTreeEntry: TreeEntry {
    
    // MARK: - Instance Properties
    
    /// The content of the entry.
    public internal(set) dynamic var content: String?
    
    /// The size of the blob in bytes.
    public internal(set) dynamic var size: Int = 0
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        content <- map["content"]
        size    <- map["size"]
    }
}
