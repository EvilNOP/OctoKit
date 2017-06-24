
//
//  User.swift
//  OctoKit
//
//  Created by Matthew on 28/12/2016.
//  Copyright © 2016 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

// A GitHub user.
//
// Users are equal if they come from the same server and have matching object
// IDs, *or* if they were both created with +userWithRawLogin:server: and their
// `rawLogin` and `server` properties are equal.
public class User: Entity {
    
    // MARK: - Instance Properties
    
    /// The username or email entered by the user.
    ///
    /// In most cases, this will be the same as the `login`. However, single sign-on
    /// systems like LDAP and CAS may have different username requirements than
    /// GitHub, meaning that the `login` may not work directly for authentication,
    /// or the `rawLogin` may not work directly with the API.
    public internal(set) dynamic var rawLogin: String?
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    /// Initialize a user that has the given name and email address.
    public convenience init(name: String, email: String) {
        self.init()
        
        self.name = name
        self.email = email
    }
    
    /// Initialize a user with the given username and server instance.
    public convenience init(login: String, server: Server) {
        self.init()
        
        self.login = login
        self.rawLogin = login
        self.server = server
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        if rawLogin == nil {
            rawLogin = login
        }
    }
}
