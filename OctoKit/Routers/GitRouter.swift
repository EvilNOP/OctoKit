//
//  GitRouter.swift
//  OctoKit
//
//  Created by Matthew on 19/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya

enum GitRouter {
    
    /// GET /repos/:owner/:repo/git/trees/:sha
    ///
    /// Get a Tree.
    case singleTree(GitParameter)
    
    /// POST /repos/:owner/:repo/git/trees
    ///
    /// Create a Tree.
    case createTree(GitParameter)
    
    /// GET /repos/:owner/:repo/git/blobs/:sha
    ///
    /// Get a Blob.
    case singleBlob(GitParameter)

    /// POST /repos/:owner/:repo/git/blobs
    ///
    /// Create a Blob.
    case createBlob(GitParameter)

    /// GET /repos/:owner/:repo/git/commits/:sha
    ///
    /// Get a Commit.
    case singleCommit(GitParameter)
    
    /// POST /repos/:owner/:repo/git/commits
    ///
    /// Create a Commit.
    case createCommit(GitParameter)

    /// GET /repos/:owner/:repo/git/refs/:ref
    ///
    /// Get a single Reference.
    case singleReference(GitParameter)
    
    /// GET /repos/:owner/:repo/git/refs
    ///
    /// Get all References.
    case allReferences(GitParameter)

    /// PATCH /repos/:owner/:repo/git/refs/:ref
    ///
    /// Update a Reference.
    case updateReference(GitParameter)
}

// MARK: - TargetType
extension GitRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .singleTree(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/git/trees/\(parameter.SHA)"
        case .createTree(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/git/trees"
        case .singleBlob(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/git/blobs/\(parameter.SHA)"
        case .createBlob(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/git/blobs"
        case .singleCommit(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/git/commits/\(parameter.SHA)"
        case .createCommit(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/git/commits"
        case .singleReference(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/git/refs/\(parameter.ref)"
        case .allReferences(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/git/refs"
        case .updateReference(let parameters):
            return "/repos/\(parameters.login)/\(parameters.repositoryName)/git/refs/\(parameters.ref)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createTree, .createBlob, .createCommit:
            return .post
        case .updateReference:
            return .patch
        default:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .singleTree(let parameter),
             .createTree(let parameter),
             .createBlob(let parameter),
             .createCommit(let parameter),
             .updateReference(let parameter):
            
            return parameter.toJSON()
        default:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .createTree, .createBlob, .createCommit:
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
