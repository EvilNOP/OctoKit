
//
//  Client+Repositories.swift
//  OctoKit
//
//  Created by Matthew on 15/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public extension Client {
    
    /// Fetches the repositories of the current `user`.
    ///
    /// - returns: A signal which sends zero or more Repository objects. Private
    ///            repositories will only be included if the client is `authenticated`. If no
    ///            `user` is set, the signal will error immediately.
    public func fetchUserRepositories(fetchAllPages: Bool = false) -> Observable<Repository> {
        if isAuthenticated {
            return provider.request(
                MultiTarget(RepositoriesRouter.authenticatedUserRepositories), fetchAllPages: fetchAllPages
            )
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
    
    /// Fetches the public repositories for the specified `user`.
    ///
    /// - parameter user:    The specified user. This must not be nil.
    ///
    /// - parameter offset:  Allows you to specify an offset at which items will begin being
    ///                      returned.
    ///
    /// - parameter perPage: The perPage parameter. You can set a custom page size up to 100 and
    ///                      the default value 30 will be used if you pass 0 or greater than 100.
    ///
    /// - returns: A signal which sends zero or more Repository objects. Private
    ///            repositories will not be included.
    public func fetchPublicRepositories(for user: User, offset: Int = 0, perPage: Int = 30,
                                        fetchAllPages: Bool = false) -> Observable<Repository> {
        guard let login = user.login else {
            fatalError("`user.login` must not be nil.")
        }
        
        var parameter = RepositoriesParameter(login: login)
        
        let perPage = provider.perPage(with: perPage)
        
        let pageOffset = provider.pageOffset(offset, perPage: perPage)
        
        parameter.page = provider.page(with: offset, perPage: perPage)
        parameter.perPage = perPage
        
        return provider.request(
            MultiTarget(RepositoriesRouter.userRepositories(parameter)), fetchAllPages: fetchAllPages
        ).skip(pageOffset)
    }
    
    /// Fetches the starred repositories of the current `user`.
    ///
    /// - returns: A signal which sends zero or more Repository objects. Private
    ///            repositories will only be included if the client is `authenticated`. If no
    ///            `user` is set, the signal will error immediately.
    public func fetchStarredRepositories(for user: User? = nil, offset: Int = 0, perPage: Int = 30,
                                         fetchAllPages: Bool = false) -> Observable<Repository> {
        if user == nil {
            if isAuthenticated {
                return provider.request(
                    MultiTarget(RepositoriesRouter.authenticatedUserStarredRepositories), fetchAllPages: fetchAllPages
                )
            }
            
            return Observable.error(
                ClientError.authenticationRequired(ClientError.authenticationRequiredError)
            )
        }
        
        guard let login = user!.login else {
            fatalError("`user.login` must not be nil.")
        }
        
        var parameter = RepositoriesParameter(login: login)
        
        let perPage = provider.perPage(with: perPage)
        
        let pageOffset = provider.pageOffset(offset, perPage: perPage)
        
        parameter.page =  provider.page(with: offset, perPage: perPage)
        parameter.perPage = perPage
        
        return provider.request(
            MultiTarget(RepositoriesRouter.userStarredRepositories(parameter)), fetchAllPages: fetchAllPages
        ).skip(pageOffset)
    }
    
    /// Fetches trending repositories.
    ///
    /// - returns: A signal which sends zero or more Repository objects. Private
    ///            repositories will only be included if the client is `authenticated`. If no
    ///            `user` is set, the signal will error immediately.
    func fetchTrendingRepositories(since: String? = nil,
                                   language: String? = nil) -> Observable<[Repository]> {
        var parameter = RepositoriesParameter()
        
        parameter.since = since
        parameter.language = language
        
        return provider.request(
            MultiTarget(RepositoriesRouter.trendingRepositories(parameter))
        ).validate().mapArray(Repository.self)
    }
    
    /// Fetches public repositories.
    ///
    /// - parameter fetchAllPages: Whether fetch all pages.
    ///
    /// - returns: A signal which sends zero or more Repository objects. Private
    ///            repositories will only be included if the client is `authenticated`. If no
    ///            `user` is set, the signal will error immediately.
    func fetchPublicRepositories(fetchAllPages: Bool = false) -> Observable<Repository> {
        return provider.request(
            MultiTarget(RepositoriesRouter.publicRepositories), fetchAllPages: fetchAllPages
        )
    }
    
    /// Fetches the specified organization's repositories.
    ///
    /// - returns: A signal which sends zero or more Repository objects. Private
    ///            repositories will only be included if the client is `authenticated` and the
    ///            `user` has permission to see them.
    public func fetchRepositories(for organization: Organization,
                                  fetchAllPages: Bool = false) -> Observable<Repository> {
        guard let login = user!.login else {
            fatalError("`organization.login` must not be nil.")
        }
        
        let parameter = RepositoriesParameter(login: login)
        
        return provider.request(
            MultiTarget(RepositoriesRouter.organizationRepositories(parameter)), fetchAllPages: fetchAllPages
        )
    }
    
    /// Creates a repository under the user's account.
    ///
    /// - returns: A signal which sends the new Repository. If the client is not
    ///            `authenticated`, the signal will error immediately.
    public func createRepository(with name: String, organization: Organization? = nil,
                                 team: Team? = nil, description: String? = nil,
                                 isPrivate: Bool = false) -> Observable<Repository> {
        if isAuthenticated {
            var parameter = RepositoriesParameter()
            
            parameter.name = name
            parameter.isPrivate = isPrivate
            parameter.description = description
            parameter.teamID = team?.id
            
            if organization == nil {
                return provider.request(
                    MultiTarget(RepositoriesRouter.createRepository(parameter))
                ).validate().mapObject(Repository.self)
            } else {
                parameter.organizationlogin = organization!.name ?? ""
                
                return provider.request(
                    MultiTarget(RepositoriesRouter.createRepositoryInOrganization(parameter))
                ).validate().mapObject(Repository.self)
            }
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
    
    /// Fetches the content at `relativePath` at the given `reference` from the
    /// `repository`.
    ///
    /// In case `relativePath` is `nil` the contents of the repository root will be
    /// sent.
    ///
    /// - parameter repository:   The repository from which the file should be fetched.
    ///
    /// - parameter relativePath: The relative path (from the repository root) of the file that
    ///                           should be fetched, may be `nil`.
    ///
    /// - parameter reference:    The name of the commit, branch or tag, may be `nil` in which
    ///                           case it defaults to the default repo branch.
    ///
    /// - returns: A signal which will send zero or more Contents depending on if the
    ///            relative path resolves at all or, resolves to a file or directory.
    public func fetchContents(in repository: Repository, at relativePath: String = "",
                              reference: String? = nil) -> Observable<[Content]> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        var parameter = RepositoriesParameter(
            login: login, repositoryName: repositoryName, path: relativePath
        )
        
        parameter.reference = reference
        
        return provider.request(
            MultiTarget(RepositoriesRouter.contents(parameter))
        ).validate().map { response -> [Content] in
                var contents: [Content] = []
                
                let json = try? response.mapJSON()
                
                // The response will be json dictionary if content is a file, otherwise,
                // will be json array if content is directory.
                if json != nil {
                    if json is [String : Any] {
                        let content = try? response.mapObject(Content.self)
                        
                        if content != nil {
                            contents.append(content!)
                        }
                    } else if json is [[String : Any]] {
                        let directory = try? response.mapArray(Content.self)
                        
                        if directory != nil {
                            contents = directory!
                        }
                    }
                }
                
                return contents
        }
    }
    
    /// Fetches the readme of a `repository`.
    ///
    /// - parameter repository: The repository for which the readme should be fetched.
    ///
    /// - returns: A signal which will send zero or one Content.
    public func fetchReadme(of repository: Repository, reference: String = "") -> Observable<String> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        var parameter = RepositoriesParameter(login: login, repositoryName: repositoryName)
        
        parameter.ref = reference
        
        return provider.request(
            MultiTarget(RepositoriesRouter.README(parameter))
        ).validate().mapString()
    }
    
    /// Fetches a specific repository owned by the given `owner` and named `name`.
    ///
    /// - parameter name:  The name of the repository, must be a non-empty string.
    ///
    /// - parameter owner: The owner of the repository, must be a non-empty string.
    ///
    /// - returns: A signal of zero or one Repository.
    public func fetchRepository(with name: String, owner: String) -> Observable<Repository> {
        let parameter = RepositoriesParameter(login: owner, repositoryName: name)
        
        return provider.request(
            MultiTarget(RepositoriesRouter.singleRepository(parameter))
        ).validate().mapObject(Repository.self)
    }
    
    /// Fetches all branches of a specific repository owned by the given `owner` and named `name`.
    ///
    /// - parameter name:  The name of the repository, must be a non-empty string.
    ///
    /// - parameter owner: The owner of the repository, must be a non-empty string.
    ///
    /// - returns: A signal of zero or one Branch.
    public func fetchBranchesForRepository(with name: String, owner: String,
                                           fetchAllPages: Bool = false) -> Observable<Branch> {
        let parameter = RepositoriesParameter(login: owner, repositoryName: name)
        
        return provider.request(
            MultiTarget(RepositoriesRouter.repositoryBranches(parameter)), fetchAllPages: fetchAllPages
        )
    }
    
    /// Fetches all open pull requests (returned as issues) of a specific
    /// repository owned by the given `owner` and named `name`.
    ///
    /// - parameter name:  The name of the repository, must be a non-empty string.
    ///
    /// - parameter owner: The owner of the repository, must be a non-empty string.
    ///
    /// - returns: A signal of zero or one PullRequest.
    public func fetchPullRequestsForRepository(with name: String, owner: String,
                                               state: PullRequestState = .open,
                                               fetchAllPages: Bool = false) -> Observable<PullRequest> {
        var parameter = RepositoriesParameter(login: owner, repositoryName: name)
        
        parameter.state = state.rawValue
        
        return provider.request(
            MultiTarget(RepositoriesRouter.repositoryPullRequests(parameter)), fetchAllPages: fetchAllPages
        )
    }
    
    /// Fetches a single pull request on a specific repository owned by the
    /// given `owner` and named `name` and with the pull request number 'number'.
    ///
    /// - parameter name:   The name of the repository, must be a non-empty string.
    ///
    /// - parameter owner:  The owner of the repository, must be a non-empty string.
    ///
    /// - parameter number: The pull request number on the repository, must be integer
    ///
    /// - returns: A signal of zero or one PullRequest.
    public func fetchSinglePullRequestForRepository(with name: String, owner: String,
                                                    number: Int) -> Observable<PullRequest> {
        let parameter = RepositoriesParameter(login: owner, repositoryName: name, number: number)
        
        return provider.request(
            MultiTarget(RepositoriesRouter.singlePullRequest(parameter))
        ).validate().mapObject(PullRequest.self)
    }
    
    /// Create a pull request in the repository.
    ///
    /// - parameter repository: The repository on which the pull request will be created.
    ///                         Cannot be nil.
    ///
    /// - parameter title:      The title for the pull request. Cannot be nil.
    ///
    /// - parameter body:       The body for the pull request. May be nil.
    ///
    /// - parameter baseBranch: The name of the branch into which the changes will be merged.
    ///                         Cannot be nil.
    ///
    /// - parameter headBranch: The name of the branch which will be brought into `baseBranch`.
    ///                         Cannot be nil.
    ///
    /// - returns: A signal of an PullRequest.
    public func createPullRequest(in repository: Repository, title: String,
                                  body: String, baseBranch: String,
                                  headBranch: String) -> Observable<PullRequest> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        var parameter = RepositoriesParameter(login: login, repositoryName: repositoryName)
        
        parameter.title = title
        parameter.body = body
        parameter.baseBranch = baseBranch
        parameter.headBranch = headBranch
        
        return provider.request(
            MultiTarget(RepositoriesRouter.createPullRequest(parameter))
        ).validate().mapObject(PullRequest.self)
    }
    
    /// Fetches commits of the given `repository` filtered by `SHA`.
    /// If no SHA is given, the commit history of all branches is returned.
    ///
    /// - parameter repository: The repository to fetch from.
    ///
    /// - parameter SHA:        SHA or branch to start listing commits from.
    ///
    /// - returns: A signal of zero or one GitCommit.
    public func fetchCommits(from repository: Repository, SHA: String? = nil,
                             fetchAllPages: Bool = false) -> Observable<GitCommit> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        var parameter = RepositoriesParameter(login: login, repositoryName: repositoryName)
        
        parameter.repositoryCommitsSHA = SHA
        
        return provider.request(
            MultiTarget(RepositoriesRouter.repositoryCommits(parameter)), fetchAllPages: fetchAllPages
        )
    }
    
    /// Fetches a single commit specified by the `SHA` from a `repository`.
    ///
    /// - parameter repository: The repository to fetch from.
    ///
    /// - parameter SHA:        The SHA of the commit.
    ///
    /// - returns: A signal of zero or one GitCommit.
    public func fetchSingleCommit(from repository: Repository, SHA: String) -> Observable<GitCommit> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        let parameter = RepositoriesParameter(login: login, repositoryName: repositoryName, SHA: SHA)
        
        return provider.request(
            MultiTarget(RepositoriesRouter.singleCommit(parameter))
        ).validate().mapObject(GitCommit.self)
    }
    
    /// Fetches the statuses for the specified `reference` in the repository with the
    /// given `name` and owned by the given `owner`.
    ///
    /// - parameter name:      The name of the repository, must be a non-empty string.
    ///
    /// - parameter owner:     The owner of the repository, must be a non-empty string.
    ///
    /// - parameter reference: The name of the commit, branch or tag, must be a non-empty string.
    ///
    /// - returns: A signal of zero or more GitCommitStatus.
    public func fetchCommitStatusesForRepository(with name: String, owner: String, reference: String,
                                                 fetchAllPages: Bool = false) -> Observable<CommitStatus> {
        let parameter = RepositoriesParameter(login: owner, repositoryName: name, ref: reference)
        
        return provider.request(
            MultiTarget(RepositoriesRouter.refCommitStatuses(parameter)), fetchAllPages: fetchAllPages
        )
    }
    
    /// Fetches the combined status for the specified `reference` in the repository
    /// with the given `name` and owned by the given `owner`.
    ///
    /// - parameter name:      The name of the repository, must be a non-empty string.
    ///
    /// - parameter owner:     The owner of the repository, must be a non-empty string.
    ///
    /// - parameter reference: The name of the commit, branch or tag, must be a non-empty string.
    ///
    /// - returns: A signal of zero or one CommitCombinedStatus.
    public func fetchCommitCombinedStatusForRepository(
        with name: String, owner: String, reference: String) -> Observable<CommitCombinedStatus> {
        let parameter = RepositoriesParameter(login: owner, repositoryName: name, ref: reference)
        
        return provider.request(
            MultiTarget(RepositoriesRouter.refCombinedStatus(parameter))
        ).validate().mapObject(CommitCombinedStatus.self)
    }
}
