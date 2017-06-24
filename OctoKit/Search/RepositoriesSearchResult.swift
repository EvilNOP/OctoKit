//
//  RepositoriesSearchResult.swift
//  OctoKit
//
//  Created by Matthew on 03/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

/// Represents the results of search repositories method.
public class RepositoriesSearchResult: Object {
    
    // MARK: - Instance Properties
    
    /// The total repositories count of the search results.
    public internal(set) dynamic var totalCount: Int = 0
    
    /// Indicates whether the results incomplete or not.
    let incompleteResults = RealmOptional<Bool>()
    
    /// The repository array of the search results.
    let repositories = List<Repository>()
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        var repositoriesArray: [Repository] = []
        
        repositoriesArray       <- map["items"]
        
        repositories.append(objectsIn: repositoriesArray)
        
        totalCount              <- map["total_count"]
        incompleteResults.value <- map["incomplete_results"]
    }
}
