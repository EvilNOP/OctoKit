//
//  SearchParameter.swift
//  OctoKit
//
//  Created by Matthew on 16/06/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

struct SearhParameter: Mappable {
    
    // MARK: - Repositories
    
    var query: String?
    
    var order: String?
    
    var sort: Bool?
    
    // MARK: - Lifecycle
    
    init(query: String?, order: String? = "desc") {
        self.query = query
        self.order = order
    }
    
    init?(map: Map) {
        self.init(query: "")
    }
    
    // MARK: - Mapping
    
    mutating func mapping(map: Map) {
        query <- map["q"]
        order <- map["order"]
        sort  <- map["sort"]
    }
}
