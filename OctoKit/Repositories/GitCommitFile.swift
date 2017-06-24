//
//  GitCommitFile.swift
//  OctoKit
//
//  Created by Matthew on 31/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A file of a commit.
public class GitCommitFile: Object {
    
    // MARK: - Instance Properties
    
    /// The filename in the repository.
    public private(set) dynamic var filename: String?
    
    /// The number of additions made in the commit.
    public private(set) dynamic var countOfAdditions: Int = 0
    
    /// The number of deletions made in the commit.
    public private(set) dynamic var countOfDeletions: Int = 0
    
    /// The number of changes made in the commit.
    public private(set) dynamic var countOfChanges: Int = 0
    
    /// The status of the commit, e.g. 'added' or 'modified'.
    public private(set) dynamic var status: String?
    
    /// The GitHub URL for the whole file.
    public private(set) dynamic var rawURLString: String?
    
    /// The GitHub blob URL.
    public private(set) dynamic var blobURLString: String?
    
    /// The patch on this file in a commit.
    public private(set) dynamic var patch: String?
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        rawURLString     <- map["raw_url"]
        blobURLString    <- map["blob_url"]
        countOfChanges   <- map["changes"]
        countOfAdditions <- map["additions"]
        countOfDeletions <- map["deletions"]
    }
}
