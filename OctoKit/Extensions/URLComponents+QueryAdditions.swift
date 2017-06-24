//
//  URLComponents+QueryAdditions.swift
//  OctoKit
//
//  Created by Matthew on 05/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

public extension URLComponents {
    
    public func queryValue(for itemName: String) -> String? {
        guard queryItems != nil else {
            return nil
        }
        
        for queryItem in queryItems! where queryItem.name.lowercased() == itemName {
            return queryItem.value
        }
        
        return nil
    }
}
