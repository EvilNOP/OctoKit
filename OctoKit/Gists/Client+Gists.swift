//
//  Client+Gists.swift
//  OctoKit
//
//  Created by Matthew on 29/12/2016.
//  Copyright © 2016 Matthew. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper

extension Client {
    
    /// Fetches the gists since the date for the specified user.
    ///
    /// - parameter user:  The specified user.
    ///
    /// - parameter since: If not nil, only gists updated at or after this time are returned.
    ///                    If nil, all the gists are returned.
    ///
    /// - parameter fetchAllPages: Whether fetch all pages.
    ///
    /// - returns: A signal which will send zero or more Gists and complete. If the client
    ///            is not `authenticated`, the signal will error immediately.
    public func fetchGists(for user: User? = nil, since: Date? = nil,
                           fetchAllPages: Bool = false) -> Observable<Gist> {
        if user == nil {
            if isAuthenticated {
                var parameter = GistsParameter()
                
                if since != nil {
                    parameter.since = ISO8601DateTransform().transformToJSON(since!)
                }
                
                return provider.request(
                    MultiTarget(GistsRouter.authenticatedUserGists(parameter)), fetchAllPages: fetchAllPages
                )
            } else {
                return Observable.error(ClientError.userRequired(ClientError.userNameRequiredError))
            }
        }
        
        var parameter = GistsParameter(login: user!.login ?? "")
        
        if since != nil {
            parameter.since = ISO8601DateTransform().transformToJSON(since!)
        }
        
        return provider.request(
            MultiTarget(GistsRouter.userGists(parameter)), fetchAllPages: fetchAllPages
        )
    }
    
    /// Fetches public gists.
    ///
    /// - parameter since: If not nil, only gists updated at or after this time are returned.
    ///                    If nil, all the gists are returned.
    ///
    /// - parameter fetchAllPages: Whether fetch all pages.
    ///
    /// - returns: A signal which will send zero or more Gists and complete.
    public func fetchPublicGists(since: Date? = nil, fetchAllPages: Bool = false) -> Observable<Gist> {
        var parameter = GistsParameter()
        
        if since != nil {
            parameter.since = ISO8601DateTransform().transformToJSON(since!)
        }
        
        return provider.request(
            MultiTarget(GistsRouter.publicGists(parameter)), fetchAllPages: fetchAllPages
        )
    }
    
    /// Creates a gist using the given changes.
    ///
    /// - parameter gistEdit: The changes to use for creating the gist. This must not be nil.
    ///
    /// - returns: A signal which will send the created Gist and complete. If the client
    ///            is not `authenticated`, the signal will error immediately.
    public func createGist(_ gistEdit: GistEdit) -> Observable<Gist> {
        if isAuthenticated {
            return provider.request(
                MultiTarget(GistsRouter.createGist(gistEdit))
            ).validate().mapObject(Gist.self)
        }
        
        return Observable.error(ClientError.userRequired(ClientError.userNameRequiredError))
    }
    
    /// Edits one or more files within a gist.
    ///
    /// - parameter gistEdit: The changes to make to the gist. This must not be nil.
    ///                       gist - The gist to modify. This must not be nil.
    ///
    /// - returns: A signal which will send the updated Gist and complete. If the client
    ///            is not `authenticated`, the signal will error immediately.
    public func editGist(_ gistEdit: GistEdit) -> Observable<Gist>  {
        if isAuthenticated {
            return provider.request(
                MultiTarget(GistsRouter.editGist(gistEdit))
            ).validate().mapObject(Gist.self)
        }
        
        return Observable.error(ClientError.userRequired(ClientError.userNameRequiredError))
    }
    
    /// Delete a gist.
    ///
    /// - parameter gist: The gist to delete. This must not be nil.
    ///
    /// - returns: A signal which will send completed on success. If the client
    ///            is not `authenticated`, the signal will error immediately.
    public func deleteGist(_ gist: Gist) -> Observable<Response> {
        if isAuthenticated {
            return provider.request(
                MultiTarget(GistsRouter.deleteGist(gist))
            ).validate()
        }
        
        return Observable.error(ClientError.userRequired(ClientError.userNameRequiredError))
    }
}
