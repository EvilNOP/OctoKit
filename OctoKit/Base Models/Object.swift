//
//  Object.swift
//  OctoKit
//
//  Created by Matthew on 27/12/2016.
//  Copyright © 2016 Matthew. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

/// The base model class for any objects retrieved through the GitHub API.
public class Object: RealmSwift.Object, Mappable {
    
    // MARK: - Instance Properties
    
    /// The unique ID for this object. This is only guaranteed to be unique among
    /// objects of the same type, from the same server.
    ///
    /// By default, the JSON representation for this property assumes a numeric
    /// representation (which is the case for most API objects).
    public internal(set) dynamic var id: Int = 0
    
    /// The server this object is associated with.
    ///
    /// This object is not encoded into JSON.
    public internal(set) var server: Server = Server.shared
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - PrimaryKey
    
    class public override func primaryKey() -> String? {
        return "id"
    }

    // MARK: - Mapping
    
    public func mapping(map: Map) {
        id <- map["id"]
    }
    
    // MARK: - Custom String Convertible
    
    public override var description: String {
        return toJSONString(prettyPrint: true) ?? ""
    }
}
