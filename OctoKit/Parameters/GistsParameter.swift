//
//  GistsParameter.swift
//  OctoKit
//
//  Created by Matthew on 13/06/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

struct GistsParameter: OwnerType, IdentifiableType, TimelineType, PaginationType , Mappable {
    
    // MARK: - OwnerType
    
    var login: String
    
    // MARK: - IdentifiableType
    
    var identity: Int
    
    // MARK: - TimelineType
    
    var since: String?
    
    // MARK: - PaginationType
    
    var page: Int?
    
    var perPage: Int?
    
    // MARK: - Lifecycle
    
    init(login: String = "", identity: Int = 0) {
        self.login = login
        self.identity = identity
    }
    
    init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    mutating func mapping(map: Map) {
        since   <- map["since"]
        
        page    <- map["page"]
        perPage <- map["per_page"]
    }
}
