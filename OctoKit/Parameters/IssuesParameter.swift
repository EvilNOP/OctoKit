//
//  IssuesParameter.swift
//  OctoKit
//
//  Created by Matthew on 15/06/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

struct IssuesParameter: RepositoryOwnerType, TimelineType , PaginationType , Mappable {
    
    // MARK: - OwnerType
    
    var login: String
    
    // MARK: - RepositoryOwnerType
    
    var repositoryName: String
    
    // MARK: - TimelineType
    
    var since: String?
    
    // MARK: - CreateIssue
    
    var title: String?
    
    var body: String?
    
    var milestone: Int?
    
    var labels: [String]?
    
    // MARK: - RepositoryIssues
    
    var issueState: String?
    
    // MARK: - PaginationType
    
    var page: Int?
    
    var perPage: Int?
    
    // MARK: - Lifecycle
    
    init(login: String, repositoryName: String) {
        self.login = login
        self.repositoryName = repositoryName
    }
    
    init?(map: Map) {
        self.login = ""
        self.repositoryName = ""
    }
    
    // MARK: - Mapping
    
    mutating func mapping(map: Map) {
        since      <- map["since"]
        
        title      <- map["title"]
        body       <- map["body"]
        milestone  <- map["milestone"]
        labels     <- map["labels"]
        
        issueState <- map["state"]
        
        page       <- map["page"]
        perPage    <- map["per_page"]
    }
}
