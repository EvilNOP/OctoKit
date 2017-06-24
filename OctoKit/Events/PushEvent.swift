//
//  PushEvent.swift
//  OctoKit
//
//  Created by Matthew on 16/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

/// Some commits got pushed.
public class PushEvent: Event {
    
    // MARK: - Instance Properties
    
    /// The number of commits included in this push.
    ///
    /// Merges count for however many commits were introduced by the other branch.
    public internal(set) dynamic var commitCount: Int = 0
    
    /// The number of distinct commits included in this push.
    public internal(set) dynamic var distinctCommitCount: Int = 0
    
    /// The SHA for HEAD prior to this push.
    public internal(set) dynamic var previousHeadSHA: String?
    
    /// The SHA for HEAD after this push.
    public internal(set) dynamic var currentHeadSHA: String?
    
    /// The branch to which the commits were pushed.
    public internal(set) dynamic var branchName: String?
    
    /// The commits were pushed, in which was the NSDictionary object.
    let commits = List<GitCommit>()
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        var commitsArray: [GitCommit] = []
        
        commitsArray        <- map["payload.commits"]
        
        commits.append(objectsIn: commitsArray)
        
        commitCount         <- map["payload.size"]
        distinctCommitCount <- map["payload.distinct_size"]
        previousHeadSHA     <- map["payload.before"]
        currentHeadSHA      <- map["payload.head"]
        branchName          <- map["payload.ref"]
    }
}
