//
//  Client+Notifications.swift
//  OctoKit
//
//  Created by Matthew on 03/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper

public extension Client {
    
    /// Conditionally fetch unread notifications for the user. If the latest data
    /// matches `etag`, the call does not count toward the API rate limit.
    ///
    /// - parameter notMatchingEtag:              An Etag from a previous request, used to avoid downloading
    ///                                           unnecessary data.
    ///
    /// - parameter isIncludingReadNotifications: Whether to include notifications that have already been
    ///                                           read.
    ///
    /// - parameter since:                        If not nil, only notifications updated after this date
    ///                                           will be included.
    ///
    /// - returns: A signal which will zero or more Responses (of Notifications)
    ///            if new data was downloaded. On success, the signal will send completed
    ///            regardless of whether there was new data. If the client is not
    ///            `authenticated`, the signal will error immediately.
    public func fetchNotifications(_ notMatchingEtag: String? = nil,
                                   isIncludingReadNotifications: Bool, since: Date? = nil,
                                   fetchAllPages: Bool = false) -> Observable<Notification> {
        if isAuthenticated {
            var parameter = NotificationsParameter()
            
            parameter.all = isIncludingReadNotifications
            // etag
            
            if since != nil {
                parameter.since = ISO8601DateTransform().transformToJSON(since!)
            }
            
            return provider.request(
                MultiTarget(NotificationsRouter.authenticatedUserNotifications(parameter)),
                fetchAllPages: fetchAllPages
            )
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
    
    /// Mark a notification thread as having been read.
    ///
    /// - parameter threadID: The id of the thread to mark as read. Cannot be nil.
    ///
    /// - returns: A signal which will send completed on success. If the client is not
    ///            `authenticated`, the signal will error immediately.
    func markNotificationThreadAsRead(for threadID: String, isRead: Bool) -> Observable<Response> {
        if isAuthenticated {
            let parameter = NotificationsParameter(identity: Int(threadID)!)
            
            return provider.request(MultiTarget(NotificationsRouter.markThreadAsRead(parameter))).validate()
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
    
    /// Mutes all further notifications from a thread.
    ///
    /// - parameter threadID: The id of the thread to mute. Cannot be nil.
    ///
    /// - returns: A signal which will send completed on success. If the client is not
    ///            `authenticated`, the signal will error immediately.
    func setNotificationThreadSubscription(_ subscription: Bool , for threadID: String,
                                           isIgnored: Bool) -> Observable<Response> {
        if isAuthenticated {
            var parameter = NotificationsParameter(identity: Int(threadID)!)
            
            parameter.subscription = subscription
            parameter.isIgnored = isIgnored
            
            return provider.request(
                MultiTarget(NotificationsRouter.setSubscription(parameter))
            ).validate()
        }
        
        return Observable.error(ClientError.authenticationRequired(ClientError.authenticationRequiredError))
    }
}
