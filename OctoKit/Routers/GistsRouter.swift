//
//  GistsRouter.swift
//  OctoKit
//
//  Created by Matthew on 28/12/2016.
//  Copyright © 2016 Matthew. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

/// You can read public gists and create them for anonymous users without a token
/// However, to read or write gists on a user's behalf the gist OAuth scope is required.
enum GistsRouter  {
    
    /// GET /gists
    ///
    /// Get the authenticated user's gists.
    case authenticatedUserGists(GistsParameter)
    
    /// GET /users/:username/gists
    ///
    /// List public gists for the specified user.
    case userGists(GistsParameter)
    
    /// GET /gists/public
    ///
    /// Get all public gists sorted by most recently updated to least recently updated.
    case publicGists(GistsParameter)
    
    /// POST /gists
    ///
    /// Create a gist.
    case createGist(GistEdit)
    
    /// PATCH /gists/:id
    ///
    /// Edit a gist.
    case editGist(GistEdit)
    
    // DELETE /gists/:id
    ///
    /// Delete a gist.
    case deleteGist(Gist)
}

// MARK: - TargetType
extension GistsRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .authenticatedUserGists, .createGist:
            return "/gists"
        case .userGists(let parameter):
            return "/users/\(parameter.login)/gists"
        case .publicGists:
            return "/gists/public"
        case .editGist(let gistEdit):
            return "/gists/\(gistEdit.id)"
        case .deleteGist(let gist):
            return "/gists/\(gist.gistID!)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createGist:
            return .post
        case .editGist:
            return .patch
        case .deleteGist:
            return .delete
        default:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .authenticatedUserGists(let parameter),
             .userGists(let parameter),
             .publicGists(let parameter):
            
            return parameter.toJSON()
        case .createGist(let gistEdit),
             .editGist(let gistEdit):
            return gistEdit.toJSON()
        default:
            return nil
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .createGist, .editGist:
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

extension GistsRouter: MutableType {
    
    mutating func withParameters(_ parameters: [String : Any]?) {
        guard parameters != nil, let gistsParameter = Mapper<GistsParameter>().map(JSON: parameters!) else {
            return
        }
        
        switch self {
        case .authenticatedUserGists:
            self = .authenticatedUserGists(gistsParameter)
        case .userGists:
            self = .userGists(gistsParameter)
        case .publicGists:
            self = .publicGists(gistsParameter)
        default:
            break
        }
    }
}
