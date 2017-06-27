//
//  Client+Watching.swift
//  OctoKit
//
//  Created by Matthew on 10/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public extension Client {
    
    /// Check if the user watched the `repository`.
    ///
    /// - parameter repository: The repository used to check the watched status. Cannot be nil.
    ///
    /// - returns: A signal, which will send a Bool valued true or false.
    ///            If the client is not `authenticated`, the signal will error immediately.
    func isWatchingRepository(_ repository: Repository) -> Observable<Bool> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        if isAuthenticated {
            var parameters: [String : String] = [ : ]
            
            parameters["owner"] = repository.ownerLogin
            parameters["repoName"] = repository.name
            
            let parameter = WatchingParameter(login: login, repositoryName: repositoryName)
            
            return provider.request(
                MultiTarget(WatchingRouter.repositorySubscription(parameter))
            ).map { response in
                response.statusCode == 204
            }
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
    
    /// Control whether or not to watch and receive notifications from a repository.
    ///
    /// - parameter repository: The repository in which to start watching. This must not be nil.
    ///
    /// - returns: A signal which will send complete, or error.
    func startWatchingRepository(_ repository: Repository,
                                 isIgnoringNotifications: Bool = false) -> Observable<Bool> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        if isAuthenticated {
            var parameter = WatchingParameter(login: login, repositoryName: repositoryName)
            
            parameter.isIgnoringNotifications = isIgnoringNotifications
            
            return provider.request(
                MultiTarget(WatchingRouter.setRepositorySubscription(parameter))
            ).validate().map { response in
                response.statusCode == 200
            }
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
    
    /// Stops watching the repository.
    ///
    /// - parameter repository: The repository in which to stop watching. This must not be nil.
    ///
    /// - returns: A signal which will send complete, or error.
    public func stopWatchingRepository(_ repository: Repository) -> Observable<Bool> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        if isAuthenticated {
            let parameter = WatchingParameter(login: login, repositoryName: repositoryName)
            
            return provider.request(
                MultiTarget(WatchingRouter.deleteRepositorySubscription(parameter))
            ).validate().map { response in
                response.statusCode == 204
            }
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
}
