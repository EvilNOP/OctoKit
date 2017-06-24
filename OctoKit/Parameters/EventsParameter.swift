//
//  EventsParameter.swift
//  OctoKit
//
//  Created by Matthew on 13/06/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

struct EventsParameter: OwnerType, PaginationType, Mappable {
    
    // MARK: - OwnerType
    
    var login: String
    
    // MARK: - PaginationType
    
    var page: Int?
    
    var perPage: Int?
    
    // MARK: - Lifecycle
    
    init(login: String) {
        self.login = login
    }
    
    init?(map: Map) {
        self.login = ""
    }
    
    // MARK: - Mapping
    
    mutating func mapping(map: Map) {
        page    <- map["page"]
        perPage <- map["per_page"]
    }
}
