//
//  Content.swift
//  OctoKit
//
//  Created by Matthew on 26/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

/// A class cluster for content in a repository, hereforth just “item”.
/// Such as files, directories, symlinks and submodules.
public class Content: RealmSwift.Object, StaticMappable {
    
    // MARK: - Instance Properties
    
    /// The type of content.
    public internal(set) dynamic var type: String?
    
    /// The size of the content, in bytes.
    public internal(set) dynamic var size: Int = 0
    
    /// The name of the item.
    public internal(set) dynamic var name: String?
    
    /// The relative path from the repository root to the item.
    public internal(set) dynamic var path: String?
    
    /// The sha reference of the item.
    public internal(set) dynamic var SHA: String?
    
    // MARK: - Lifecycle
    
    public class func objectForMapping(map: Map) -> BaseMappable? {
        func contentMaker(contentType: ContentType) -> BaseMappable {
            switch contentType {
            case .file:
                return FileContent()
            case .dir:
                return DirectoryContent()
            case .symlink:
                return SymlinkContent()
            case .submodule:
                return SubmoduleContent()
            }
        }
        
        if let typeString = map.JSON["type"] as? String, let contentType = ContentType(rawValue: typeString) {
            return contentMaker(contentType: contentType)
        } else if let contentType = map.JSON["type"] as? ContentType {
            return contentMaker(contentType: contentType)
        }
        
        return nil
    }
    
    // MARK: - Mapping
    
    public func mapping(map: Map) {
//        let transform = TransformOf<ContentType, String>(fromJSON: { value in
//            guard let typeString = value else {
//                return nil
//            }
//            
//            return ContentType(rawValue: typeString)
//        }, toJSON: { value in
//            guard let contentType = value else {
//                return nil
//            }
//            
//            return contentType.rawValue
//        })
        
        type <- map["type"]
        size <- map["size"]
        name <- map["name"]
        path <- map["path"]
        SHA  <- map["sha"]
    }
    
    // MARK: - Custom String Convertible
    
    public override var description: String {
        return toJSONString(prettyPrint: true) ?? ""
    }
}

