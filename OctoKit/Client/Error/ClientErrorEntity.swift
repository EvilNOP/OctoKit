//
//  ResponseError.swift
//  OctoKit
//
//  Created by Matthew on 09/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// The three possible types of client errors on API calls that receive request bodies:
///
/// One:   Sending invalid JSON will result in a 400 Bad Request response.
///
/// Two:   Sending the wrong type of JSON values will result in a 400 Bad Request response.
///
/// Three: Sending invalid fields will result in a 422 Unprocessable Entity response.
public class ClientErrorEntity: Mappable {
    
    // MARK: - Instance Properties
    
    /// Describe what the error is.
    public internal(set) var message: String?
    
    public internal(set) var documentationURL: URL?
    
    /// Tell what the problem is.
    public internal(set) var errors: [ErrorObject]?
    
    // MARK: - Lifecycle
    
    public required init?(map: Map) {
        // Keys of client error entity json should no more than 3.
        if map.JSON.keys.count > 3 {
            return nil
        }
    }
    
    // MARK: - Mapping
    
    public func mapping(map: Map) {
        message          <- map["message"]
        documentationURL <- (map["documentation_url"], URLTransform(shouldEncodeURLString: false))
        errors           <- map["errors"]
    }
}

// MARK: - Custom String Convertible
extension ClientErrorEntity: CustomStringConvertible {
    
    public var description: String {
        guard let description = toJSONString(prettyPrint: true) else {
            return ""
        }
        
        return description
    }
}
