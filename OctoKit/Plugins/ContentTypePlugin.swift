//
//  ContentTypePlugin.swift
//  OctoKit
//
//  Created by Matthew on 06/06/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya

/// Provides each request with content type.
public final class ContentTypePlugin: PluginType {
    
    // MARK: - Type alias
    
    public typealias ContentType = String
    
    public typealias ContentTypeClosure = (TargetType) -> ContentType?
    
    // MARK: - Instance Properties
    
    let contentTypeClosure: ContentTypeClosure
    
    // MARK: - Lifecycle
    
    public init(contentTypeClosure: @escaping ContentTypeClosure) {
        self.contentTypeClosure = contentTypeClosure
    }
    
    // MARK: Plugin
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        request.addValue(contentTypeClosure(target) ?? StableContentType, forHTTPHeaderField: "Accept")
        
        return request
    }
}
