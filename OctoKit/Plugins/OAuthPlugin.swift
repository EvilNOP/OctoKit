//
//  OAuthPlugin.swift
//  OctoKit
//
//  Created by Matthew on 07/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya

/// Provides each request with token.
public final class OAuthPlugin: PluginType {
    
    let token: String
    
    public init(token: String) {
        self.token = token
    }
    
    // MARK: Plugin
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        request.addValue("token \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
