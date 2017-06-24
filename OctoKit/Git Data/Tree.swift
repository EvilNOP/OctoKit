//
//  Tree.swift
//  OctoKit
//
//  Created by Matthew on 19/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

/// A git tree.
public class Tree: Object {
    
    // MARK: - Instance Properties
    
    /// The SHA of the tree.
    public internal(set) var SHA: String?
    
    /// The URL for the tree.
    public internal(set) var URLString: String?
    
    /// The `TreeEntry` objects.
    let entries = List<TreeEntry>()
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()   
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        var entriesArray: [TreeEntry] = []
        
        entriesArray <- map["tree"]
        
        entries.append(objectsIn: entriesArray)
        
        SHA          <- map["sha"]
        URLString    <- map["url"]
    }
}
