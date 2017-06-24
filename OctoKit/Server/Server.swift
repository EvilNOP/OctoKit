//
//  Server.swift
//  OctoKit
//
//  Created by Matthew on 27/12/2016.
//  Copyright © 2016 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// Represents a GitHub server instance
/// (ie. github.com or an Enterprise instance)
public class Server {
    
    // MARK: - Singleton
    
    static public let shared: Server = Server(baseURL: nil)
    
    // MARK: - Instance Properties
    
    // The base URL to the instance associated with this server
    private(set) var baseURL: URL?
    
    // MARK: - Computed Properties
    
    /// The base URL to the website for the instance (the
    /// Enterprise landing page or github.com).
    ///
    /// This URL is constructed from the baseURL.
    public var baseWebURL: URL {
        guard baseURL != nil else {
            return URL(string: ServerDotComBaseWebURL)!
        }
        
        return baseURL!
    }
    
    /// Returns true if this is an Enterprise instance
    public var isEnterprise: Bool {
        return baseURL != nil
    }
    
    /// The base URL to the API we should use for requests to this server
    /// (i.e., Enterprise or github.com).
    ///
    /// This URL is constructed from the baseURL.
    public var APIEndpoint: URL {
        if baseURL == nil {
            // This environment variable can be used to debug API requests by
            // redirecting them to a different URL.
            if let endpoint = ProcessInfo.processInfo.environment["API_ENDPOINT"] {
                return URL(string: endpoint)!
            } else {
                return URL(string: ServerDotComAPIEndpoint)!
            }
        } else {
            return baseURL!.appendingPathComponent(
                ServerEnterpriseAPIEndpointPathComponent, isDirectory: true
            )
        }
    }

    // MARK: - Lifecycle
    
    private init() {
        
    }
    
    public init(baseURL: URL?) {
        self.baseURL = baseURL
    }
}
