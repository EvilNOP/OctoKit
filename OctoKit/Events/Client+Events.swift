//
//  Client+Events.swift
//  OctoKit
//
//  Created by Matthew on 18/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public extension Client {
    
    // MARK: - Event
    
    /// Conditionally fetches events from the current user's activity stream. If
    /// the latest data matches `etag`, the call does not count toward the API rate
    /// limit.
    ///
    /// - parameter etag: An Etag from a previous request, used to avoid downloading
    ///                   unnecessary data.
    ///
    /// - returns: A signal which will send zero or more Responses (of Events) if
    ///            new data was downloaded. Unrecognized events will be omitted from the result.
    ///            On success, the signal will send completed regardless of whether there was
    ///            new data. If no `user` is set, the signal will error immediately.
    public func fetchUserReceivedEvents(_ notMatchingEtag: String? = nil,
                                        fetchAllPages: Bool = false) -> Observable<Event> {
        guard let user = self.user, let login = user.login else {
            return Observable.error(ClientError.userRequired(ClientError.userNameRequiredError))
        }
        
        return provider.request(
            MultiTarget(EventsRouter.userReceivedEvents(EventsParameter(login: login))),
            fetchAllPages: fetchAllPages
        )
    }
    
    /// Fetches the received events of the current user.
    ///
    /// - parameter offset:  Allows you to specify an offset at which items will begin being
    ///                      returned.
    ///
    /// - parameter perPage: The perPage parameter. You can set a custom page size up to 100 and
    ///                      the default value 30 will be used if you pass 0 or greater than 100.
    ///
    /// - returns: A signal which sends zero or more Event objects.
    public func fetchUserReceivedEvents(with offset: Int = 0, perPage: Int = 30,
                                        fetchAllPages: Bool = false) -> Observable<Event> {
        guard let user = self.user, let login = user.login else {
            return Observable.error(ClientError.userRequired(ClientError.userNameRequiredError))
        }
        
        let page = provider.page(with: offset, perPage: perPage)
        
        let perPage = provider.perPage(with: perPage)
        
        let pageOffset = provider.pageOffset(offset, perPage: perPage)

        var parameter = EventsParameter(login: login)
        
        parameter.page = page
        
        return provider.request(
            MultiTarget(EventsRouter.userReceivedEvents(parameter)), fetchAllPages: fetchAllPages
        ).skip(pageOffset)
    }
    
    /// Fetches the performed events for the specified `user`.
    ///
    /// - parameter user:    The specified user. This must not be nil.
    ///
    /// - parameter offset:  Allows you to specify an offset at which items will begin being
    ///                      returned.
    ///
    /// - parameter perPage: The perPage parameter. You can set a custom page size up to 100 and
    ///                      the default value 30 will be used if you pass 0 or greater than 100.
    ///
    /// - returns: A signal which sends zero or more Event objects.
    public func fetchPerformedEvents(for user: User, offset: Int = 0, perPage: Int = 30,
                                     fetchAllPages: Bool = false) -> Observable<Event> {
        guard let login = user.login else {
            return Observable.error(ClientError.userRequired(ClientError.userNameRequiredError))
        }
        
        let page = provider.page(with: offset, perPage: perPage)
        
        let perPage = provider.perPage(with: perPage)
        
        let pageOffset = provider.pageOffset(offset, perPage: perPage)
        
        var parameter = EventsParameter(login: login)
        
        parameter.page = page
        
        return provider.request(
            MultiTarget(EventsRouter.userPerformedEvents(parameter)), fetchAllPages: fetchAllPages
        ).skip(pageOffset)
    }
}
