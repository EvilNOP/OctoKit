//
//  Client+Activity.swift
//  OctoKit
//
//  Created by Matthew on 04/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public extension Client {
    
    /// Check if the user starred the `repository`.
    ///
    /// - parameter repository: The repository used to check the starred status. Cannot be nil.
    ///
    /// - returns: A signal, which will send a Bool valued true or false.
    ///            If the client is not `authenticated`, the signal will error immediately.
    public func hasUserStarredRepository(_ repository: Repository) -> Observable<Bool> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        if isAuthenticated {
            let parameter = RepositoriesParameter(login: login, repositoryName: repositoryName)
            
            return provider.request(
                MultiTarget(RepositoriesRouter.repositoryBeingStarred(parameter))
            ).map { response in
                response.statusCode == 204
            }
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
    
    /// Star the given `repository`
    ///
    /// - parameter repository: The repository to star. Cannot be nil.
    ///
    /// - returns: A signal, which will send completed on success. If the client
    ///            is not `authenticated`, the signal will error immediately.
    public func starRepository(_ repository: Repository) -> Observable<Bool> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        if isAuthenticated {
            let parameter = RepositoriesParameter(login: login, repositoryName: repositoryName)
            
            return provider.request(
                MultiTarget(RepositoriesRouter.starRepository(parameter))
            ).validate().map { response in
                response.statusCode == 204
            }
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
    
    /// Unstar the given `repository`
    ///
    /// - parameter repository: The repository to unstar. Cannot be nil.
    ///
    /// - returns: A signal, which will send completed on success. If the client
    ///            is not `authenticated`, the signal will error immediately.
    public func unstarRepository(_ repository: Repository) -> Observable<Bool> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        if isAuthenticated {
            let parameter = RepositoriesParameter(login: login, repositoryName: repositoryName)
            
            return provider.request(
                MultiTarget(RepositoriesRouter.unstarRepository(parameter))
            ).validate().map { response in
                response.statusCode == 204
            }
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
}
