//
//  CommitStatus.swift
//  OctoKit
//
//  Created by Matthew on 01/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A status belonging to a commit.
public class CommitStatus: Object {
    
    // MARK: - Instance Properties
    
    /// The date at which the status was originally created.
    public internal(set) dynamic var creationDate: Date?
    
    /// The date the status was last updated. This will be equal to
    /// creationDate if the status has not been updated.
    public internal(set) dynamic var updatedDate: Date?
    
    /// The state of this status.
    public internal(set) dynamic var state: String?
    
    /// The URL where more information can be found about this status. Typically this
    /// URL will display the build output for the commit this status belongs to.
    public internal(set) dynamic var targetURLString: String?
    
    /// A description for this status. Typically this will be a high-level summary of
    /// the build output for the commit this status belongs to.
    public internal(set) dynamic var statusDescription: String?
    
    /// A context indicating which service (or kind of service) provided the status.
    public internal(set) dynamic var context: String?
    
    /// The user whom created this status.
    public internal(set) dynamic var creator: User?
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override  func mapping(map: Map) {
        super.mapping(map: map)
        
        let dateTransform = ISO8601DateTransform()
        
        creationDate      <- (map["created_at"], dateTransform)
        updatedDate       <- (map["updated_at"], dateTransform)
        state             <- map["state"]
        targetURLString   <- map["target_url"]
        statusDescription <- map["description"]
        context           <- map["context"]
        creator           <- map["creator"]
    }
}
