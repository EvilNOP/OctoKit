//
//  RepositoriesParameter.swift
//  OctoKit
//
//  Created by Matthew on 15/06/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

struct RepositoriesParameter: RepositoryOwnerSHAType, RepositoryOwnerRefType, RepositoryOwnerPathType, RepositoryOwnerNumberType, OrganizationOwnerType, TimelineType, PaginationType, Mappable {
    
    // MARK: - OwnerType
    
    var login: String
    
    // MARK: - RepositoryOwnerType
    
    var repositoryName: String
    
    // MARK: - RepositoryOwnerSHAType
    
    var SHA: String
    
    // MARK: - RepositoryOwnerRefType
    
    var ref: String
    
    // MARK: - RepositoryOwnerPathType
    
    var path: String
    
    // MARK: - OrganizationOwnerType
    
    var organizationlogin: String
    
    // MARK: - RepositoryOwnerNumberType
    
    var number: Int
    
    // MARK: - TimelineType
    
    var since: String?
    
    // MARK: - TrendingRepositories
    
    var language: String?
    
    // MARK: - CreateRepository
    
    var name: String?
    
    var isPrivate: Bool?
    
    var description: String?
    
    var teamID: Int?
    
    // MARK: - Contents & README
    
    var reference: String?
    
    // MARK: - RepositoryPullRequests
    
    var state: String?
    
    // MARK: - CreatePullRequest
    
    var title: String?
    
    var body: String?
    
    var baseBranch: String?
    
    var headBranch: String?
    
    // MARK: - RepositoryCommits
    
    var repositoryCommitsSHA: String?
    
    // MARK: - PaginationType
    
    var page: Int?
    
    var perPage: Int?
    
    // MARK: - Lifecycle
    
    init(login: String = "", repositoryName: String = "", SHA: String = "",
         ref: String = "", path: String = "", number: Int = 0, organizationlogin: String = "") {
        self.login = login
        self.repositoryName = repositoryName
        self.ref = ref
        self.SHA = SHA
        self.path = path
        self.number = number
        self.organizationlogin = organizationlogin
    }
    
    init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    mutating func mapping(map: Map) {
        since                <- map["since"]
        
        language             <- map["language"]
        
        name                 <- map["name"]
        isPrivate            <- map["private"]
        description          <- map["description"]
        teamID               <- map["team_id"]
        
        reference            <- map["ref"]
        
        state                <- map["state"]
        
        title                <- map["title"]
        body                 <- map["body"]
        baseBranch           <- map["base"]
        headBranch           <- map["head"]
        
        repositoryCommitsSHA <- map["sha"]
        
        page                 <- map["page"]
        perPage              <- map["per_page"]
    }
}
