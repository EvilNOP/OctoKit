//
//  Repository.swift
//  OctoKit
//
//  Created by Matthew on 15/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

/// A GitHub repository.
public class Repository: Object {
    
    // MARK: - Instance Properties
    
    /// The name of this repository, as used in GitHub URLs.
    ///
    /// This is the second half of a unique GitHub repository name, which follows the
    /// form `ownerLogin/name`.
    public internal(set) dynamic var name: String?
    
    /// The login of the account which owns this repository.
    ///
    /// This is the first half of a unique GitHub repository name, which follows the
    /// form `ownerLogin/name`.
    public internal(set) dynamic var ownerLogin: String?
    
    /// The URL for any avatar image.
    public internal(set) dynamic var ownerAvatarURLString: String?
    
    /// The description of this repository.
    public internal(set) dynamic var repoDescription: String?
    
    /// The language of this repository.
    public internal(set) dynamic var language: String?
    
    /// Whether this repository is private to the owner.
    let isPrivate = RealmOptional<Bool>()
    
    /// Whether this repository is a fork of another repository.
    let isFork = RealmOptional<Bool>()
    
    /// The date of the last push to this repository.
    public internal(set) dynamic var pushedDate: Date?
    
    /// The created date of this repository.
    public internal(set) dynamic var creationDate: Date?
    
    /// The last updated date of this repository.
    public internal(set) dynamic var updatedDate: Date?
    
    /// The number of watchers for this repository.
    public internal(set) dynamic var watchersCount: Int = 0
    
    /// The number of forks for this repository.
    public internal(set) dynamic var forksCount: Int = 0
    
    /// The number of stargazers for this repository.
    public internal(set) dynamic var stargazersCount: Int = 0
    
    /// The number of open issues for this repository.
    public internal(set) dynamic var openIssuesCount: Int = 0
    
    /// The number of subscribers for this repository.
    public internal(set) dynamic var subscribersCount: Int = 0
    
    /// The URL for pushing and pulling this repository over HTTPS.
    public internal(set) dynamic var HTTPSURLString: String?
    
    /// The URL for pushing and pulling this repository over SSH, formatted as
    /// a string because SSH URLs are not correctly interpreted by NSURL.
    public internal(set) dynamic var SSHURLString: String?
    
    /// The URL for pulling this repository over the `git://` protocol.
    public internal(set) dynamic var gitURLString: String?
    
    /// The URL for visiting this repository on the web.
    public internal(set) dynamic var HTMLURLString: String?
    
    /// The default branch's name. For empty repositories, this will be nil.
    public internal(set) dynamic var defaultBranch: String?
    
    /// The URL for the issues page in a repository.
    ///
    /// An issue number may be appended (as a path component) to this path to create
    /// an individual issue's HTML URL.
    public internal(set) dynamic var issuesHTMLURLString: String?
    
    /// Text match metadata, uses to highlight the search results.
//    public internal(set) dynamic var textMatches: [String]?
    
    /// The parent of the fork, or nil if the repository isn't a fork. This is the
    /// repository from which the receiver was forked.
    ///
    /// Note that this is only populated on calls to
    /// Client.fetchRepositoryWithName:owner:.
    public internal(set) dynamic var forkParent: Repository?
    
    /// The source of the fork, or nil if the repository isn't a fork. This is the
    /// ultimate source for the network, which may be different from the
    /// `forkParent`.
    ///
    /// Note that this is only populated on calls to
    /// Client.fetchRepositoryWithName:owner:.
    public internal(set) dynamic var forkSource: Repository?
    
    // MARK: - Lifecycle
    
    public convenience init(repositoryName: String) {
        self.init()
        
        ownerLogin = "EvilNOP"
        name = repositoryName
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        let dateTransform = ISO8601DateTransform()
        
        name                 <- map["name"]
        HTTPSURLString       <- map["clone_url"]
        SSHURLString         <- map["ssh_url"]
        gitURLString         <- map["git_url"]
        HTMLURLString        <- map["html_url"]
        ownerLogin           <- map["owner.login"]
        language             <- map["language"]
        isPrivate.value      <- map["private"]
        isFork.value         <- map["fork"]
        ownerAvatarURLString <- map["owner.avatar_url"]
        pushedDate           <- (map["pushed_at"], dateTransform)
        creationDate         <- (map["created_at"], dateTransform)
        updatedDate          <- (map["updated_at"], dateTransform)
        watchersCount        <- map["watchers_count"]
        forksCount           <- map["forks_count"]
        stargazersCount      <- map["stargazers_count"]
        openIssuesCount      <- map["open_issues_count"]
        subscribersCount     <- map["subscribers_count"]
        repoDescription      <- map["description"]
        defaultBranch        <- map["default_branch"]
        forkParent           <- map["parent"]
        forkSource           <- map["source"]
    }
}
