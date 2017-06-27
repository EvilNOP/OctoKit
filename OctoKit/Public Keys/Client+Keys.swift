//
//  Client+Keys.swift
//  OctoKit
//
//  Created by Matthew on 27/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public extension Client {
    
    /// Fetches the public keys for the current `user`.
    ///
    /// - returns: A signal which sends zero or more PublicKey objects. Unverified
    ///            keys will only be included if the client is `authenticated`. If no `user` is
    ///            set, the signal will error immediately.
    public func fetchPublicKeys(fetchAllPages: Bool = false) -> Observable<PublicKey> {
        if isAuthenticated {
            return provider.request(
                MultiTarget(UsersRouter.userPublicKeys), fetchAllPages: fetchAllPages
            )
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
    
    /// Adds a new public key to the current user's profile.
    ///
    /// - returns: A signal which sends the new PublicKey. If the client is not
    ///            `authenticated`, the signal will error immediately.
    public func postPublicKey(with title: String, key: String) -> Observable<PublicKey> {
        if isAuthenticated {
            var parameters: [String : String] = [ : ]
            
            parameters["title"] = title
            parameters["key"] = key
            
            var parameter = UsersParameter()
            
            parameter.title = title
            parameter.key = key
            
            return provider.request(
                MultiTarget(UsersRouter.createPublicKey(parameter))
            ).validate().mapObject(PublicKey.self)
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
}
