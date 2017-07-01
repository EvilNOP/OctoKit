//
//  EventsRouter.swift
//  OctoKit
//
//  Created by Matthew on 11/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

enum EventsRouter {
    
    /// GET /users/:username/received_events
    ///
    /// Get the events that a user has received.
    case userReceivedEvents(EventsParameter)
    
    /// GET /users/:username/events
    ///
    /// Get the events performed by a user.
    case userPerformedEvents(EventsParameter)
}

// MARK: - TargetType
extension EventsRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .userReceivedEvents(let parameter):
            return "/users/\(parameter.login)/received_events"
        case .userPerformedEvents(let parameter):
            return "/users/\(parameter.login)/events"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .userReceivedEvents(let eventsParameter),
             .userPerformedEvents(let eventsParameter):
            
            return eventsParameter.toJSON()
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

// MARK: - MutableType
extension EventsRouter: MutableType {
    
    mutating func withParameters(_ parameters: [String : Any]?) {
        guard parameters != nil, let eventsParameter = Mapper<EventsParameter>().map(JSON: parameters!) else {
            return
        }
        
        switch self {
        case .userReceivedEvents:
            self = .userReceivedEvents(eventsParameter)
        case .userPerformedEvents:
            self = .userPerformedEvents(eventsParameter)
        }
    }
}
