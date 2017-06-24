//
//  IssuesRouter.swift
//  OctoKit
//
//  Created by Matthew on 01/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya

enum IssuesRouter {
    
    /// POST /repos/:owner/:repo/issues
    ///
    /// Create an issue.
    case createIssue(IssuesParameter)
    
    /// GET /repos/:owner/:repo/issues
    ///
    /// Get issues for a repository.
    case repositoryIssues(IssuesParameter)
}

// MARK: - TargetType
extension IssuesRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .createIssue(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/issues"
        case .repositoryIssues(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/issues"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createIssue:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .createIssue(let parameter):
            return parameter.toJSON()
        default:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .createIssue:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .request
    }
}
