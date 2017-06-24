//
//  CommitCombinedStatus.swift
//  OctoKit
//
//  Created by Matthew on 01/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper


/// A combined status for a commit.
public class CommitCombinedStatus: Object {
    
    // MARK: - Instance Properties
    
    /// The combined state for the commit this combined status belongs to.
    public internal(set) dynamic var state: String?
    
    /// The SHA of commit this combined status belongs to.
    public internal(set) dynamic var SHA: String?
    
    /// The number of statuses that make up this combined status.
    public internal(set) dynamic var countOfStatuses: Int = 0
    
    /// The statuses that make up this combined status.
    let statuses = List<CommitStatus>()
    
    /// The repository to which the associated commit belongs.
    public internal(set) dynamic var repository: Repository?
    
    /// The URL for the commit this combined status belongs to.
    public internal(set) dynamic var commitURLString: String?
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        var statusesArray: [CommitStatus] = []
        
        statusesArray        <- map["statuses"]
        
        statuses.append(objectsIn: statusesArray)
        
        state                <- map["state"]
        SHA                  <- map["sha"]
        countOfStatuses      <- map["total_count"]
        repository           <- map["repository"]
        commitURLString      <- map["commit_url"]
    }
}
