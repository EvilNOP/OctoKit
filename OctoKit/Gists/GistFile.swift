//
//  GistFile.swift
//  OctoKit
//
//  Created by Matthew on 28/12/2016.
//  Copyright © 2016 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

// A single file within a gist.
public class GistFile: Object {
    
    // MARK: - Instance Properties
    
    /// The path to this file within the gist.
    public internal(set) var filename: String?
    
    /// A direct URL to the raw file contents.
    public internal(set) var rawURLString: String?
    
    /// The size of the file, in bytes.
    public internal(set) var size: Int = 0
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        filename     <- map["filename"]
        rawURLString <- map["raw_url"]
        size         <- map["size"]
    }
}
