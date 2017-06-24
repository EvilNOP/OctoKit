//
//  Entity.swift
//  OctoKit
//
//  Created by Matthew on 27/12/2016.
//  Copyright © 2016 Matthew. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

/// Represents any GitHub object which is capable of owning repositories.
public class Entity: Object {
    
    // MARK: - Instance Properties
    
    /// The unique name for this entity, used in GitHub URLs.
    public internal(set) dynamic var login: String?
    
    /// The full name of this entity.
    ///
    /// Returns `login` if no name is explicitly set.
    public internal(set) dynamic var name: String?

    /// The short biography associated with this account.
    public internal(set) dynamic var bio: String?
    
    /// The Repository objects associated with this entity.
    ///
    /// Client endpoints do not actually set this property. It is provided as
    /// a convenience for persistence and model merging.
    let repositories = List<Repository>()
    
    /// The email address for this account.
    public internal(set) dynamic var email: String?
    
    /// The URL for any avatar image.
    public internal(set) dynamic var avatarURLString: String?
    
    /// The web URL for this account.
    public internal(set) dynamic var HTMLURLString: String?
    
    /// A reference to a blog associated with this account.
    public internal(set) dynamic var blog: String?
    
    /// The name of a company associated with this account.
    public internal(set) dynamic var company: String?
    
    // The location associated with this account.
    public internal(set) dynamic var location: String?
    
    /// The total number of collaborators that this account has on their private repositories.
    public internal(set) dynamic var collaborators: Int = 0
    
    /// The number of public repositories owned by this account.
    public internal(set) dynamic var publicRepoCount: Int = 0
    
    /// The number of private repositories owned by this account.
    public internal(set) dynamic var privateRepoCount: Int = 0
    
    /// The number of public gists owned by this account.
    public internal(set) dynamic var publicGistCount: Int = 0
    
    /// The number of private gists owned by this account.
    public internal(set) dynamic var privateGistCount: Int = 0
    
    /// The number of followers for this account.
    public internal(set) dynamic var followers: Int = 0
    
    /// The number of following for this account.
    public internal(set) dynamic var following: Int = 0
    
    /// The number of kilobytes occupied by this account's repositories on disk.
    public internal(set) dynamic var diskUsage: Int = 0
    
    /// The plan that this account is on.
    public internal(set) dynamic var plan: Plan?
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        // The name will be the same as `login` if no name is explicitly set.
        if name == nil {
            name = login
        }
        
        login            <- map["login"]
        name             <- map["name"]
        bio              <- map["bio"]
        email            <- map["email"]
        avatarURLString  <- map["avatar_url"]
        HTMLURLString    <- map["html_url"]
        blog             <- map["blog"]
        company          <- map["company"]
        location         <- map["location"]
        collaborators    <- map["collaborators"]
        publicRepoCount  <- map["public_repos"]
        privateRepoCount <- map["owned_private_repos"]
        publicGistCount  <- map["public_gists"]
        privateGistCount <- map["private_gists"]
        followers        <- map["followers"]
        following        <- map["following"]
        diskUsage        <- map["disk_usage"]
        plan             <- map["plan"]
    }
}
