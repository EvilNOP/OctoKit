//
//  Client+Issues.swift
//  OctoKit
//
//  Created by Matthew on 01/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper

public extension Client {
    
    /// Creates an issue.
    ///
    /// - parameter title:      The title of the issue. This must not be nil.
    ///
    /// - parameter body:       The contents of the issue. This can be nil.
    ///
    /// - parameter milestone:  Milestone to associate this issue with. NOTE: Only users with
    ///                         push access can set the milestone for new issues. The milestone
    ///                         is silently dropped otherwise. This can be nil.
    ///
    /// - parameter labels:     Labels to associate with this issue. NOTE: Only users with push
    ///                         access can set labels for new issues. Labels are silently dropped
    ///                         otherwise. This can be nil.
    ///
    /// - parameter repository: The repository in which to create the issue. This must not be nil.
    ///
    /// - returns: A signal which will send the created `Issue` then complete, or error.
    public func createIssue(with title: String, body: String, milestone: Int,
                            labels: [String], in repository: Repository) -> Observable<Issue> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        var parameter = IssuesParameter(login: login, repositoryName: repositoryName)
        
        parameter.title = title
        parameter.body = body
        parameter.milestone = milestone
        parameter.labels = labels
        
        return provider.request(
            MultiTarget(IssuesRouter.createIssue(parameter))
        ).validate().mapObject(Issue.self)
    }
    
    /// Fetch the issues with the given state from the repository.
    ///
    /// - parameter repository: The repository whose issues should be fetched. Cannot be nil.
    ///
    /// - parameter state:      The state of issues to return.
    ///
    /// - parameter etag:       An Etag from a previous request, used to avoid downloading
    ///                         unnecessary data. May be nil.
    ///
    /// - parameter since:      Only issues updated or created after this date will be fetched.
    ///                         May be nil.
    ///
    /// - returns: A signal which will send each `Response`-wrapped `Issue`s and
    ///            complete or error.
    public func fetchIssues(for repository: Repository, state: IssueState,
                            notMatchingEtag etag: String? = nil, since: Date? = nil,
                            fetchAllPages: Bool = false) -> Observable<Issue> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        var parameter = IssuesParameter(login: login, repositoryName: repositoryName)
        
        parameter.issueState = state.rawValue
        // etag
        
        if since != nil {
            parameter.since = ISO8601DateTransform().transformToJSON(since!)
        }
        
        return provider.request(
            MultiTarget(IssuesRouter.repositoryIssues(parameter)), fetchAllPages: fetchAllPages
        )
    }
}
