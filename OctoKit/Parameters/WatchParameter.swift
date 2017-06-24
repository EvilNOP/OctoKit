//
//  WatchParameter.swift
//  OctoKit
//
//  Created by Matthew on 16/06/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

struct WatchingParameter: RepositoryOwnerType, Mappable {
    
    // MARK: - OwnerType
    
    var login: String
    
    // MARK: - RepositoryOwnerType
    
    var repositoryName: String
    
    // MARK: - SetRepositorySubscription
    
    var isIgnoringNotifications: Bool?
    
    // MARK: - Lifecycle
    
    init(login: String = "", repositoryName: String = "") {
        self.login = login
        self.repositoryName = repositoryName
    }
    
    init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    mutating func mapping(map: Map) {
        isIgnoringNotifications <- map["ignored"]
    }
}
