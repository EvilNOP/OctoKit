//
//  FileContent.swift
//  OctoKit
//
//  Created by Matthew on 26/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A file in a git repository.
public class FileContent: Content {
    
    // MARK: - Instance Properties
    
    /// The encoding of the file content.
    public internal(set) dynamic var encoding: String?
    
    /// The raw, encoded, content of the file.
    ///
    /// See `encoding` for the encoding used.
    public internal(set) dynamic var content: String?
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        encoding <- map["encoding"]
        content  <- map["content"]
    }
}
