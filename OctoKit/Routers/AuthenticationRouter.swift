//
//  AuthenticationRouter.swift
//  OctoKit
//
//  Created by Matthew on 05/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya

enum AuthenticationRouter {
    
    /// GET /login/oauth/authorize
    ///
    /// Redirect users to request GitHub identity.
    case identity
    
    /// POST /login/oauth/access_token
    ///
    /// Exchange oauth code for an access token.
    case exchangeCodeForAccessToken(AuthenticationParameter)
    
    /// PUT /authorizations/clients/:client_id
    ///
    /// Get-or-create an authorization for a specific app.
    case getOrCreateAuthorization(AuthenticationParameter)
    
    /// DELETE /authorizations/:id
    ///
    /// Delete an authorization.
    case deleteAuthorization(AuthenticationParameter)
}

// MARK: - TargetType
extension AuthenticationRouter: TargetType {
    
    var baseURL: URL {
        switch self {
        case .getOrCreateAuthorization, .deleteAuthorization:
            return URL(string: "https://api.github.com")!
        default:
            return URL(string: "https://github.com")!
        }
    }
    
    var path: String {
        switch self {
        case .identity:
            return "/login/oauth/authorize"
        case .exchangeCodeForAccessToken:
            return "/login/oauth/access_token"
        case .getOrCreateAuthorization(let parameter):
            return "/authorizations/clients/\(parameter.clientID!)"
        case .deleteAuthorization(let parameter):
            return "/authorizations/\(parameter.identity)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .exchangeCodeForAccessToken:
            return .post
        case .getOrCreateAuthorization:
            return .put
        case .deleteAuthorization:
            return .delete
        default:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .exchangeCodeForAccessToken(let parameter),
             .getOrCreateAuthorization(let parameter):
            
            return parameter.toJSON()
        default:
            return nil
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .deleteAuthorization:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .request
    }
}
