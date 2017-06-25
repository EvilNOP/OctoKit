//
//  Client+User.swift
//  OctoKit
//
//  Created by Matthew on 07/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public extension Client {
    
    /// Fetches the full information of the current `user` or the given user.
    ///
    /// - returns: A signal which sends a new User. The user may contain different
    ///            levels of information depending on whether the client is `authenticated` or
    ///            not. If no `user` is set, the signal will error immediately.
    public func fetchUserInformation(for user: User? = nil) -> Observable<User> {
        // Fetches the full information of the given `user`
        if user != nil {
            guard let login = user!.login else {
                fatalError("`user.login`must not be nil.")
            }
            
            let parameter = UsersParameter(login: login)
            
            return provider.request(
                MultiTarget(UsersRouter.singleUser(parameter))
            ).validate().mapObject(User.self)
        }
        
        if isAuthenticated {
            return provider.request(
                MultiTarget(UsersRouter.authenticatedUser)
            ).validate().mapObject(User.self)
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
    
    /// Fetches the followers for the specified `user`.
    ///
    /// - parameter user:    The specified user. This must not be nil.
    ///
    /// - parameter offset:  Allows you to specify an offset at which items will begin being
    ///                      returned.
    ///
    /// - parameter perPage: The perPage parameter. You can set a custom page size up to 100 and
    ///                      the default value 30 will be used if you pass 0 or greater than 100.
    ///
    /// - returns: A signal which sends zero or more User objects.
    public func fetchFollowers(for user: User, offset: Int = 0, perPage: Int = 30,
                               fetchAllPages: Bool = false) -> Observable<User> {
        guard let login = user.login else {
            fatalError("`user.login` must not be nil.")
        }
        
        var parameter = UsersParameter(login: login)
        
        parameter.perPage = provider.perPage(with: perPage)
        
        let pageOffset = provider.pageOffset(offset, perPage: perPage)
        
        parameter.page =  provider.page(with: offset, perPage: perPage)
        
        return provider.request(
            MultiTarget(UsersRouter.followers(parameter)), fetchAllPages: fetchAllPages
        ).skip(pageOffset)
    }
    
    /// Fetches the following for the specified `user`.
    ///
    /// - parameter user:    The specified user. This must not be nil.
    ///
    /// - parameter offset:  Allows you to specify an offset at which items will begin being returned.
    ///
    /// - parameter perPage: The perPage parameter. You can set a custom page size up to 100 and
    ///                      the default value 30 will be used if you pass 0 or greater than 100.
    ///
    /// - returns: A signal which sends zero or more User objects.
    public func fetchFollowing(for user: User, offset: Int = 0, perPage: Int = 30,
                               fetchAllPages: Bool = false) -> Observable<User> {
        guard let login = user.login else {
            fatalError("`user.login` must not be nil.")
        }
        
        var parameter = UsersParameter(login: login)
        
        parameter.perPage = provider.perPage(with: perPage)
        
        let pageOffset = provider.pageOffset(offset, perPage: perPage)
        
        parameter.page =  provider.page(with: offset, perPage: perPage)
        
        return provider.request(
            MultiTarget(UsersRouter.following(parameter)), fetchAllPages: fetchAllPages
        ).skip(pageOffset)
    }
    
    /// Check if the current `user` are following a user.
    ///
    /// - parameter user: The specified user. This must not be nil.
    ///
    /// - returns: A signal, which will send a Bool valued true or false.
    ///            If the client is not `authenticated`, the signal will error immediately.
    public func isFollowingUser(_ user: User) -> Observable<Bool> {
        guard let login = user.login else {
            fatalError("`user.login` must not be nil.")
        }
        
        if isAuthenticated {
            return provider.request(
                MultiTarget(UsersRouter.userBeingFollowed(UsersParameter(login: login)))
            ).map { response in
                response.statusCode == 204
            }
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
    
    /// Follow the given `user`.
    ///
    /// - parameter user: - The user to follow. Cannot be nil.
    ///
    /// - returns: A signal, which will send completed on success. If the client
    ///            is not `authenticated`, the signal will error immediately.
    public func followUser(_ user: User) -> Observable<Bool> {
        guard let login = user.login else {
            fatalError("`user.login` must not be nil.")
        }
        
        if isAuthenticated {
            return provider.request(
                MultiTarget(UsersRouter.followUser(UsersParameter(login: login)))
            ).validate().map { response in
                response.statusCode == 204
            }
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
    
    /// Unfollow the given `user`.
    ///
    /// - parameter user: - The user to unfollow. Cannot be nil.
    ///
    /// - returns: A signal, which will send completed on success. If the client
    ///            is not `authenticated`, the signal will error immediately.
    public func unfollowUser(_ user: User) -> Observable<Bool> {
        guard let login = user.login else {
            fatalError("`user.login` must not be nil.")
        }
        
        if isAuthenticated {
            return provider.request(
                MultiTarget(UsersRouter.unfollowUser(UsersParameter(login: login)))
            ).validate().map { response in
                response.statusCode == 204
            }
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
}
