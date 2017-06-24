//
//  UsersRouter.swift
//  OctoKit
//
//  Created by Matthew on 07/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya

enum UsersRouter {
    
    /// GET /users/:username
    ///
    /// Get a single user.
    case singleUser(UsersParameter)
    
    // GET /user
    ///
    /// Get the authenticated user.
    case authenticatedUser
    
    /// GET /users
    ///
    /// Get all users.
    case allUsers
    
    /// GET /users/:username/followers
    ///
    /// Get followers of a user.
    case followers(UsersParameter)
    
    /// GET /users/:username/following
    ///
    /// Get users followed by current user.
    case following(UsersParameter)
    
    /// GET /following/:username
    ///
    /// Check if the current user following another user.
    case userBeingFollowed(UsersParameter)
    
    /// PUT /following/:username
    ///
    /// Follow a user.
    case followUser(UsersParameter)
    
    /// DELETE /following/:username
    ///
    /// Unfollow a user.
    case unfollowUser(UsersParameter)
    
    /// GET /user/keys
    ///
    /// Get the current user's keys.
    case userPublicKeys
    
    /// POST /user/keys
    ///
    /// Create a public key.
    case createPublicKey(UsersParameter)
}

// MARK: - TargetType
extension UsersRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .singleUser(let parameter):
            return "/users/\(parameter.login)"
        case .authenticatedUser:
            return "/user"
        case .allUsers:
            return "/users"
        case .followers(let parameter):
            return "/users/\(parameter.login)/followers"
        case .following(let parameter):
            return "/users/\(parameter.login)/following"
        case .userBeingFollowed(let parameter):
            return "/user/following/\(parameter.login)"
        case .followUser(let parameter):
            return "/user/following/\(parameter.login)"
        case .unfollowUser(let parameter):
            return "/user/following/\(parameter.login)"
        case .userPublicKeys, .createPublicKey:
            return "/user/keys"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .followUser:
            return .put
        case .unfollowUser:
            return .delete
        case .createPublicKey:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .createPublicKey(let parameter):
            return parameter.toJSON()
        default:
            return nil
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .createPublicKey:
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
