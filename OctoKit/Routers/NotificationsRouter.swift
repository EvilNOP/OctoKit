//
//  NotificationsRouter.swift
//  OctoKit
//
//  Created by Matthew on 03/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya

enum NotificationsRouter {
    
    /// GET /notifications
    ///
    /// Get all notifications for the current user, grouped by repository.
    case authenticatedUserNotifications(NotificationsParameter)
    
    /// PATCH /notifications/threads/:id
    ///
    /// Mark a thread as read.
    case markThreadAsRead(NotificationsParameter)
    
    /// PUT /notifications/threads/:id/subscription
    ///
    /// Set a Thread Subscription.
    case setSubscription(NotificationsParameter)
}

// MARK: - TargetType
extension NotificationsRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .authenticatedUserNotifications:
            return "/notifications"
        case .markThreadAsRead(let parameter):
            return "/notifications/threads/\(parameter.identity)"
        case .setSubscription(let parameter):
            return "/notifications/threads/\(parameter.identity)/subscription"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .markThreadAsRead:
            return .patch
        case .setSubscription:
            return .put
        default:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .authenticatedUserNotifications(let parameter),
             .setSubscription(let parameter):
            
            return parameter.toJSON()
        default:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .request
    }
}
