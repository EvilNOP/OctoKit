//
//  WatchingRouter.swift
//  OctoKit
//
//  Created by Matthew on 10/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya

enum WatchingRouter {
    
    /// GET /user/subscriptions/:owner/:repo
    ///
    /// Get a Repository Subscription.
    case repositorySubscription(WatchingParameter)
    
    /// PUT /repos/:owner/:repo/subscription
    ///
    /// Control whether or not to watch and receive notifications from a repository.
    case setRepositorySubscription(WatchingParameter)
    
    /// DELETE /repos/:owner/:repo/subscription
    ///
    /// Stops watching the repository.
    case deleteRepositorySubscription(WatchingParameter)
}

// MARK: - TargetType
extension WatchingRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .repositorySubscription(let parameter):
            return "/user/subscriptions/\(parameter.login)/\(parameter.repositoryName)"
        case .setRepositorySubscription(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/subscription"
        case .deleteRepositorySubscription(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/subscription"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .repositorySubscription:
            return .get
        case .setRepositorySubscription:
            return .put
        case .deleteRepositorySubscription:
            return .delete
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .setRepositorySubscription(let parameter):
            return parameter.toJSON()
        case .repositorySubscription, .deleteRepositorySubscription:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .setRepositorySubscription:
            return JSONEncoding.default
        case .repositorySubscription, .deleteRepositorySubscription:
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
