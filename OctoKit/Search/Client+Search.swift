//
//  Client+Search.swift
//  OctoKit
//
//  Created by Matthew on 03/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public extension Client {
    
    ///  Search repositories.
    ///
    /// - parameter query:     The search keywords, as well as any qualifiers. This must not be nil.
    ///
    /// - parameter orderBy:   The sort field. One of stars, forks, or updated. Default: results
    ///                        are sorted by best match. This can be nil.
    ///
    /// - parameter ascending: The sort order, ascending or not.
    ///
    /// - returns: A signal which will send the search result `RepositoriesSearchResult`.
    public func searchRepositories(with query: String, orderBy order: String, isAscending: Bool,
                                   fetchAllPages: Bool = false) -> Observable<RepositoriesSearchResult> {
        var parameter = SearhParameter(query: query, order: isAscending ? "asc" : "desc")
        
        parameter.order = order
        
        return provider.request(
            MultiTarget(SearchRouter.repositories(parameter))
        ).validate().mapObject(RepositoriesSearchResult.self)
    }
}
