//
//  GistFileEdit.swift
//  OctoKit
//
//  Created by Matthew on 28/12/2016.
//  Copyright © 2016 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

// Changes to a single file, or a new file, within a gist.
public class GistFileEdit: Mappable {
    
    // MARK: - Instance Properties
    
    /// If not nil, the new filename to set for the file.
    public internal(set) var filename: String?
    
    /// If not nil, the new content to set for the file.
    public internal(set) var content: String?
    
    // MARK: - Lifecycle
    
    public init(filename: String, content: String) {
        self.filename = filename
        self.content = content
    }
    
    public required init?(map: Map) {
        return nil
    }
    
    // MARK: - Mapping
    
    public func mapping(map: Map) {
        filename <- map["filename"]
        content <- map["content"]
    }
}

// MARK: - Custom String Convertible
extension GistFileEdit: CustomStringConvertible {
    
    public var description: String {
        guard let description = toJSONString(prettyPrint: true) else {
            return ""
        }
        
        return description
    }
}
