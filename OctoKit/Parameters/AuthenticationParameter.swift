//
//  AuthenticationParameter.swift
//  OctoKit
//
//  Created by Matthew on 13/06/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

struct AuthenticationParameter: IdentifiableType, Mappable {
    
    // MARK: - IdentifiableType
    
    var identity: Int
    
    // MARK: - ExchangeCodeForAccessToken
    
    var oauthCode: String?
    
    // MARK: - GetOrCreateAuthorization
    
    var clientID: String?
    
    var clientSecret: String?
    
    var oneTimePassword: String?
    
    var scopes: [String]?
    
    var note: String?
    
    var noteURL: String?
    
    var fingerprint: String?
    
    // MARK: - Lifecycle
    
    init(identity: Int = 0) {
        self.identity = identity
    }
    
    init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    mutating func mapping(map: Map) {
        oauthCode       <- map["code"]
        
        clientID        <- map["clientID"]
        clientSecret    <- map["client_secret"]
        oneTimePassword <- map["oneTimePassword"]
        scopes          <- map["scopes"]
        note            <- map["note"]
        noteURL         <- map["note_url"]
        fingerprint     <- map["fingerprint"]
    }
}
