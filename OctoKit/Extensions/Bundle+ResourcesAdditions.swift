//
//  Bundle+ResourcesAdditions.swift
//  OctoKit
//
//  Created by Matthew on 07/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

public extension Bundle {
    
    public func path(forJSON name: String) -> Data {
        guard let path = Bundle.main.path(forResource: name, ofType: "json"),
            let data = Data(base64Encoded: path) else {
                return Data()
        }
        
        return data
    }
}
