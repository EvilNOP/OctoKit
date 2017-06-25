//
//  ErrorObject.swift
//  OctoKit
//
//  Created by Matthew on 09/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

public class ErrorObject: Mappable {
    
    // MARK: - Instance Properties
    
    /// Which resource is wrong.
    public internal(set) var resource: String?
    
    /// Which field on a resource is wrong.
    public internal(set) var field: String?
    
    /// The reason what is wrong with the field.
    public internal(set) var code: String?
    
    // MARK: - Lifecycle
    
    public required init?(map: Map) {
        
    }
    
    // MARK: - Mapping
    
    public func mapping(map: Map) {
        resource <- map["resource"]
        field    <- map["field"]
        code     <- map["code"]
    }
}

// MARK: - Custom String Convertible
extension ErrorObject: CustomStringConvertible {
    
    public var description: String {
        guard let description = toJSONString(prettyPrint: true) else {
            return ""
        }
        
        return description
    }
}
