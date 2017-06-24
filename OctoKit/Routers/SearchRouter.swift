//
//  SearchRouter.swift
//  OctoKit
//
//  Created by Matthew on 03/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya

enum SearchRouter {
    
    /// GET /search/repositories
    ///
    /// Find repositories via various criteria.
    case repositories(SearhParameter)
}

// MARK: - TargetType
extension SearchRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String{
        switch self {
        case .repositories:
            return "/search/repositories"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .repositories(let parameter):
            return parameter.toJSON()
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .request
    }
}
