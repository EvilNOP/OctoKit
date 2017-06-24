//
//  GitParameter.swift
//  OctoKit
//
//  Created by Matthew on 14/06/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

struct GitParameter: RepositoryOwnerSHAType, RepositoryOwnerRefType , PaginationType, Mappable {
    
    // MARK: - OwnerType
    
    var login: String
    
    // MARK: - RepositoryOwnerType
    
    var repositoryName: String
    
    // MARK: - RepositoryOwnerSHAType
    
    var SHA: String
    
    // MARK: RepositoryOwnerRefType
    
    var ref: String
    
    // MARK: - SingleTree
    
    var isRecursive: Int?
    
    // MARK: - CreateTree
    
    var treeEntries: [TreeEntry]?
    
    var baseTreeSHA: String?
    
    // MARK: - CreateBlob
    
    var content: String?
    
    var encoding: String?
    
    // MARK: - CreateCommit
    
    var message: String?
    
    var treeSHA: String?
    
    var parentSHAs: [String]?
    
    // MARK: - UpdateReference
    
    var newSHA: String?
    
    var isForced: Bool?
    
    // MARK: - PaginationType
    
    var page: Int?
    
    var perPage: Int?
    
    // MARK: - Lifecycle
    
    init(login: String, repositoryName: String, SHA: String = "", ref: String = "") {
        self.login = login
        self.repositoryName = repositoryName
        self.SHA = SHA
        self.ref = ref
    }
    
    init?(map: Map) {
        self.init(login: "", repositoryName: "")
    }
    
    // MARK: - Mapping
    
    mutating func mapping(map: Map) {
        isRecursive <- map["recursive"]
        
        treeEntries <- map["tree"]
        baseTreeSHA <- map["base_tree"]
        
        content     <- map["content"]
        encoding    <- map["encoding"]
        
        message     <- map["message"]
        treeSHA     <- map["tree"]
        parentSHAs  <- map["parents"]
        
        newSHA      <- map["sha"]
        isForced    <- map["force"]
        
        page        <- map["page"]
        perPage     <- map["per_page"]
    }
}
