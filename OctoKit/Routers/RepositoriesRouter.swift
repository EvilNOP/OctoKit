
//
//  RepositoriesRouter.swift
//  OctoKit
//
//  Created by Matthew on 15/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya

enum RepositoriesRouter {
    
    /// GET /user/repos
    ///
    /// List repositories that are accessible to the authenticated user.
    case authenticatedUserRepositories
    
    /// GET /users/:username/repos
    ///
    /// List public repositories for the specified user.
    case userRepositories(RepositoriesParameter)
    
    /// GET /user/starred
    ///
    /// List starred repositories that are accessible to the authenticated user.
    case authenticatedUserStarredRepositories
    
    /// GET /users/:username/starred
    ///
    /// List public repositories for the specified user.
    case userStarredRepositories(RepositoriesParameter)
    
    /// GET /trending
    ///
    /// List trending repositories.
    case trendingRepositories(RepositoriesParameter)
    
    /// GET /repositories
    ///
    /// List every public repository, in the order that they were created.
    case publicRepositories
    
    /// GET /orgs/:org/repos
    ///
    /// Get repositories for the specified org
    case organizationRepositories(RepositoriesParameter)
    
    /// POST /user/repos
    ///
    /// Create a new repository for the authenticated user.
    case createRepository(RepositoriesParameter)
    
    /// POST /orgs/:org/repos
    ///
    /// Create a new repository in this organization. 
    /// The authenticated user must be a member of the specified organization.
    case createRepositoryInOrganization(RepositoriesParameter)
    
    /// GET /repos/:owner/:repo/contents/:path
    ///
    /// Get the contents of a file or directory in a repository.
    case contents(RepositoriesParameter)
    
    /// GET /repos/:owner/:repo/readme
    ///
    /// Get the preferred README for a repository.
    case README(RepositoriesParameter)
    
    /// GET /repos/:owner/:repo
    ///
    /// Get a single repository.
    case singleRepository(RepositoriesParameter)
    
    /// GET /repos/:owner/:repo/branches
    ///
    /// Get the branches of the specified repository.
    case repositoryBranches(RepositoriesParameter)
    
    /// GET /repos/:owner/:repo/pulls
    ///
    /// Get the pull requests of the specified repository.
    case repositoryPullRequests(RepositoriesParameter)
    
    /// GET /repos/:owner/:repo/pulls/:number
    ///
    /// Get the single pull request of the specified repository with the pull request number.
    case singlePullRequest(RepositoriesParameter)
    
    /// POST /repos/:owner/:repo/pulls
    ///
    /// Create a pull request.
    case createPullRequest(RepositoriesParameter)
    
    /// GET /repos/:owner/:repo/commits
    ///
    /// Get the commits of the specified repository.
    case repositoryCommits(RepositoriesParameter)
    
    /// GET /repos/:owner/:repo/commits/:sha
    ///
    /// Get a single commit.
    case singleCommit(RepositoriesParameter)
    
    /// GET /repos/:owner/:repo/commits/:ref/statuses
    ///
    /// Get the statuses for a specific Ref.
    case refCommitStatuses(RepositoriesParameter)
    
    /// GET /repos/:owner/:repo/commits/:ref/status
    ///
    /// Get the combined Status for a specific Ref.
    case refCombinedStatus(RepositoriesParameter)
    
    /// GET /user/starred/:owner/:repo
    ///
    /// Check if you are starring a repository.
    case repositoryBeingStarred(RepositoriesParameter)
    
    /// PUT /user/starred/:owner/:repo
    ///
    /// Star a repository.
    case starRepository(RepositoriesParameter)
    
    /// DELETE /user/starred/:owner/:repo
    ///
    /// Unstar a repository.
    case unstarRepository(RepositoriesParameter)
}

// MARK: - TargetType
extension RepositoriesRouter: TargetType {
    
    var baseURL: URL {
        switch self {
        case .trendingRepositories:
            return URL(string: "http://trending.codehub-app.com/v2")!
        default:
            return URL(string: "https://api.github.com")!
        }
    }
    
    var path: String {
        switch self {
        case .authenticatedUserRepositories:
            return "/user/repos"
        case .userRepositories(let parameter):
            return "/users/\(parameter.login)/repos"
        case .authenticatedUserStarredRepositories:
            return "/user/starred"
        case .userStarredRepositories(let parameter):
            return "/users/\(parameter.login)/starred"
        case .trendingRepositories:
            return "/trending"
        case .publicRepositories:
            return "/repositories"
        case .organizationRepositories(let parameter):
            return "/orgs/\(parameter.login)/repos"
        case .createRepository:
            return "/user/repos"
        case .createRepositoryInOrganization(let parameter):
            return "/orgs/\(parameter.organizationlogin)/repos"
        case .contents(let parameter):
            return "repos/\(parameter.login)/\(parameter.repositoryName)/contents/\(parameter.path)"
        case .README(let parameter):
            return "repos/\(parameter.login)/\(parameter.repositoryName)/readme"
        case .singleRepository(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)"
        case .repositoryBranches(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/branches"
        case .repositoryPullRequests(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/pulls"
        case .singlePullRequest(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/pulls/\(parameter.number)"
        case .createPullRequest(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/pulls"
        case .repositoryCommits(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/commits"
        case .singleCommit(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/commits/\(parameter.SHA)"
        case .refCommitStatuses(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/commits/\(parameter.ref)/statuses"
        case .refCombinedStatus(let parameter):
            return "/repos/\(parameter.login)/\(parameter.repositoryName)/commits/\(parameter.ref)/status"
        case .repositoryBeingStarred(let parameter):
            return "/user/starred/\(parameter.login)/\(parameter.repositoryName)"
        case .starRepository(let parameter):
            return "/user/starred/\(parameter.login)/\(parameter.repositoryName)"
        case .unstarRepository(let parameter):
            return "/user/starred/\(parameter.login)/\(parameter.repositoryName)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createRepository, .createRepositoryInOrganization, .createPullRequest:
            return .post
        case .starRepository:
            return .put
        case .unstarRepository:
            return .delete
        default:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .userRepositories(let parameter),
             .userStarredRepositories(let parameter),
             .trendingRepositories(let parameter),
             .createRepository(let parameter),
             .createRepositoryInOrganization(let parameter),
             .contents(let parameter),
             .README(let parameter),
             .repositoryPullRequests(let parameter),
             .createPullRequest(let parameter),
             .repositoryCommits(let parameter):
            
            return parameter.toJSON()
        default:
            return nil
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .createRepository, .createRepositoryInOrganization, .createPullRequest:
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
