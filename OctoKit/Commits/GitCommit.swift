
//
//  GitCommit.swift
//  OctoKit
//
//  Created by Matthew on 31/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

/// A git commit.
public class GitCommit: Object {
    
    // MARK: - Instance Properties
    
    /// The commit URL for this commit.
    public internal(set) dynamic var commitURLString: String?
    
    /// The commit message for this commit.
    public internal(set) dynamic var message: String?
    
    /// The SHA for this commit.
    public internal(set) dynamic var SHA: String?
    
    /// The committer of this commit.
    public internal(set) dynamic var committer: User?
    
    /// The author of this commit.
    public internal(set) dynamic var author: User?
    
    /// The date the author signed the commit.
    public internal(set) dynamic var commitDate: Date?
    
    /// The number of changes made in the commit.
    /// This property is only set when fetching a full commit.
    public internal(set) dynamic var countOfChanges: Int = 0
    
    /// The number of additions made in the commit.
    /// This property is only set when fetching a full commit.
    public internal(set) dynamic var countOfAdditions: Int = 0
    
    /// The number of deletions made in the commit.
    /// This property is only set when fetching a full commit.
    public internal(set) dynamic var countOfDeletions: Int = 0
    
    /// The GitCommitFile objects changed in the commit.
    /// This property is only set when fetching a full commit.
    let files = List<GitCommitFile>()
    
    /// The authors git user.name property. This is only useful if the
    /// author does not have a GitHub login. Otherwise, author should
    /// be used.
    public internal(set) dynamic var authorName: String?
    
    /// The committer's git user.name property. This is only useful if the
    /// committer does not have a GitHub login. Otherwise, committer should
    /// be used.
    public internal(set) dynamic var committerName: String?
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        var filesArray: [GitCommitFile] = []
        
        filesArray       <- map["files"]
        
        files.append(objectsIn: filesArray)
        
        commitURLString  <- map["url"]
        SHA              <- map["sha"]
        message          <- map["commit.message"]
        commitDate       <- (map["commit.author.date"], ISO8601DateTransform())
        countOfChanges   <- map["stats.total"]
        countOfAdditions <- map["stats.additions"]
        countOfDeletions <- map["stats.deletions"]
        authorName       <- map["commit.author.name"]
        committerName    <- map["commit.committer.name"]
    }
}
