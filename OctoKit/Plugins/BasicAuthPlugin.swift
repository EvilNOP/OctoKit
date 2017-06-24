//
//  BasicAuthPlugin.swift
//  OctoKit
//
//  Created by Matthew on 08/03/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya

/// Provides each request with optional credentials.
public final class BasicAuthPlugin: PluginType {
    
    // MARK: - Type alias
    
    /// Username and password tuple.
    public typealias Credential = (username: String, password: String)
    
    public typealias CredentialClosure = (TargetType) -> Credential?
    
    // MARK: - Instance Properties
    
    let credentialClosure: CredentialClosure
    
    // MARK: - Lifecycle
    
    public init(credentialClosure: @escaping CredentialClosure) {
        self.credentialClosure = credentialClosure
    }
    
    // MARK: - Plugin
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        if let credential = credentialClosure(target),
           let base64Credential = encodeCredential(credential) {
            request.addValue(base64Credential, forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    // MARK: - Instance Methods
    
    /// Encode credential using Base64.
    ///
    /// - parameter credential: The credential to be encoded.
    ///
    /// - returns: Base64 encoded credential.
    private func encodeCredential(_ credential: Credential) -> String? {
        guard let credentialData = "\(credential.username):\(credential.password)".data(using: .utf8) else {
            return nil
        }
        
        let base64Credential = credentialData.base64EncodedString()
        
        return "Basic \(base64Credential)"
    }
}
