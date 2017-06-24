//
//  NotificationsParameter.swift
//  OctoKit
//
//  Created by Matthew on 15/06/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

struct NotificationsParameter: IdentifiableType, PaginationType, Mappable {
    
    // MARK: - IdentifiableType
    
    var identity: Int
    
    // MARK: - TimelineType
    
    var since: String?
    
    // MARK: - AuthenticatedUserNotifications
    
    var all: Bool?
    
    // MARK: - SetSubscription
    
    var subscription: Bool?
    
    var isIgnored: Bool?
    
    // MARK: - PaginationType
    
    var page: Int?
    
    var perPage: Int?
    
    // MARK: - Lifecycle
    
    init(identity: Int = 0) {
        self.identity = identity
    }
    
    init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    mutating func mapping(map: Map) {
        since        <- map["since"]
        
        all          <- map["all"]
        
        subscription <- map["subscribed"]
        isIgnored    <- map["ignored"]
        
        page         <- map["page"]
        perPage      <- map["per_page"]
    }
}
