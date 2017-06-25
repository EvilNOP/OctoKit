//
//  Response+Validation.swift
//  OctoKit
//
//  Created by Matthew on 09/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya

public extension Response {
    
    /// Validates the response, throws errors if validation fails.
    /// - throws: `ClientError` when others are encountered.
    /// - returns: Response.
    public func validate() throws -> Response {
        // Try to map data to `ClientErrorEntity`, if successed, indicating that errors happened.
        if let responseError = try? self.mapObject(ClientErrorEntity.self), let message = responseError.message {
            if message == ClientError.invalidJSONErrorMessage {
                throw MoyaError.underlying(ClientError.invalidJSON(responseError))
            } else if message == ClientError.jsonObjectRequiredErrorMessage {
                throw MoyaError.underlying(ClientError.jsonObjectRequired(responseError))
            } else if message == ClientError.invalidFieldsErrorMessage {
                throw MoyaError.underlying(ClientError.invalidFields(responseError))
            } else if message == ClientError.authenticationRequiredError {
                throw MoyaError.underlying(ClientError.authenticationRequired(message))
            } else if message == ClientError.badCredentialsError {
                throw MoyaError.underlying(ClientError.invalidCredentials(responseError))
            }else {
                throw MoyaError.underlying(ClientError.unknownError(responseError))
            }
        }
        
        return self
    }
}
