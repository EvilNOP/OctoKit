//
//  ClientAuthorizationScopes.swift
//  OctoKit
//
//  Created by Matthew on 06/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

/// Scopes let you specify exactly what type of access you need. 
/// Scopes limit access for OAuth tokens. 
/// They do not grant any additional permission beyond that which the user already has.
public struct ClientAuthorizationScopes: OptionSet {
    
    /// RawRepresentable
    public var rawValue = 0
    
    // MARK: - Lifecycle
    
    public init() {
        self.rawValue = 0
    }
    
    public init(rawValue: ClientAuthorizationScopes.RawValue) {
        self.rawValue = rawValue
    }
    
    // MARK: - Options
    
    /// Grants read-only access to public information 
    /// (includes public user profile info, public repository info, and gists)
    static public var publicReadOnly = ClientAuthorizationScopes(rawValue: 1 << 0)
    
    /// Grants read access to a user's email addresses.
    static public var userEmail = ClientAuthorizationScopes(rawValue: 1 << 1)
    
    /// Grants access to follow or unfollow other users.
    static public var userFollow = ClientAuthorizationScopes(rawValue: 1 << 2)
    
    /// Grants read/write access to profile info only. 
    /// Note that this scope includes user:email and user:follow.
    static public var user = ClientAuthorizationScopes(rawValue: 1 << 3)
    
    /// Grants read/write access to public and private repository commit statuses. 
    /// This scope is only necessary to grant other users or 
    /// services access to private repository commit statuses without granting access to the code.
    static public var repositoryStatus = ClientAuthorizationScopes(rawValue: 1 << 4)
    
    /// Grants read/write access to code, commit statuses, collaborators, 
    /// and deployment statuses for public repositories and organizations. 
    /// Also required for starring public repositories.
    static public var publicRepository = ClientAuthorizationScopes(rawValue: 1 << 5)
    
    /// Grants read/write access to code, commit statuses, invitations, collaborators, 
    /// adding team memberships, and deployment statuses for public 
    /// and private repositories and organizations.
    static public var repository = ClientAuthorizationScopes(rawValue: 1 << 6)
    
    /// Grants access to delete adminable repositories.
    static public var repositoryDelete = ClientAuthorizationScopes(rawValue: 1 << 7)
    
    /// Grants read access to a user's notifications. repo also provides this access.
    static public var notifications = ClientAuthorizationScopes(rawValue: 1 << 8)
    
    /// Grants write access to gists.
    static public var gist = ClientAuthorizationScopes(rawValue: 1 << 9)
    
    /// List and view details for public keys.
    static public var publicKeyRead = ClientAuthorizationScopes(rawValue: 1 << 10)
    
    /// Create, list, and view details for public keys.
    static public var publicKeyWrite = ClientAuthorizationScopes(rawValue: 1 << 11)
    
    /// Fully manage public keys.
    static public var publicKeyAdmin = ClientAuthorizationScopes(rawValue: 1 << 12)
    
    /// Read-only access to organization, teams, and membership.
    static public var orgRead = ClientAuthorizationScopes(rawValue: 1 << 13)
}
