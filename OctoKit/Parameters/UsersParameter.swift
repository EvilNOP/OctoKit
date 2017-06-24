//
//  UsersParameter.swift
//  OctoKit
//
//  Created by Matthew on 16/06/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

struct UsersParameter: OwnerType, PaginationType , Mappable {
    
    // MARK: - OwnerType
    
    var login: String
    
    // MARK: - CreatePublicKey
    
    var title: String?
    
    var key: String?
    
    // MARK: - PaginationType
    
    var page: Int?
    
    var perPage: Int?
    
    // MARK: - Lifecycle
    
    init(login: String = "") {
        self.login = login
    }
    
    init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        key   <- map["key"]
        
        page    <- map["page"]
        perPage <- map["per_page"]
    }
}
