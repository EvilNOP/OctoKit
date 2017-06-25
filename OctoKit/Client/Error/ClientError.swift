//
//  ClientError.swift
//  OctoKit
//
//  Created by Matthew on 08/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

public enum ClientError: Error {
    
    static public let invalidJSONErrorMessage        = "Problems parsing JSON"
    static public let jsonObjectRequiredErrorMessage = "Body should be a JSON object"
    static public let invalidFieldsErrorMessage      = "Validation Failed"
    
    static public let userNameRequiredError          = "Username Required"
    static public let authenticationRequiredError    = "Requires authentication"
    static public let unsupportedServerError         = "Unsupported server"
    static public let badRequestError                = "Bad Request"
    static public let badCredentialsError            = "Bad credentials"
    static public let requestForbiddenError          = "RequestForbidden"
    static public let serviceRequestFailedError      = "serviceRequestFailed"
    static public let openingBrowserFailedError      = "Could not open web browser, " +
                                                       "please make sure you have a default web browser set."
    
    /// Indicates a response failed due to no username was provided.
    case userRequired(String)
    
    /// Indicates a response failed due to the unauthentication.
    case authenticationRequired(String)
    
    /// Indicates a response failed due to unsupported Server.
    case unsupportedVersion(String)
    
    /// Indicates a response failed due to sending the wrong type of JSON values.
    case jsonObjectRequired(ClientErrorEntity)
    
    /// Indicates a response failed due to sending invalid JSON to the server.
    case invalidJSON(ClientErrorEntity)
    
    /// Indicates a response failed due to sending invalid fields.
    case invalidFields(ClientErrorEntity)
    
    /// Indicates a response failed due to bad request.
    case badRequest(String)
    
    /// Indicates a response failed due to forbidden request.
    case requestForbidden(String)
    
    /// Indicates a response failed due to failed service request.
    case serviceRequestFailed(String)
    
    /// Indicates a response failed due to failed to open browser.
    case openingBrowserFailed
    
    /// Indicates a response failed due to invalid credentials.
    case invalidCredentials(ClientErrorEntity)
    
    /// Indicates a response failed due to the unknown error.
    case unknownError(ClientErrorEntity)
}

extension ClientError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .userRequired:
            return ClientError.userNameRequiredError
        case .authenticationRequired:
            return ClientError.authenticationRequiredError
        case .unsupportedVersion:
            return ClientError.unsupportedServerError
        case .jsonObjectRequired(let errorEntity):
            return errorEntity.message ?? "Sending the wrong type of JSON values"
        case .invalidJSON(let errorEntity):
            return errorEntity.message ?? "Sending invalid JSON to the server"
        case .invalidFields(let errorEntity):
            return errorEntity.message ?? "Validation Failed"
        case .badRequest:
            return ClientError.badRequestError
        case .requestForbidden:
            return ClientError.requestForbiddenError
        case .serviceRequestFailed:
            return ClientError.serviceRequestFailedError
        case .openingBrowserFailed:
            return ClientError.openingBrowserFailedError
        case .invalidCredentials(let errorEntity):
            return errorEntity.message ?? ClientError.badCredentialsError
        case .unknownError(let errorEntity):
            return errorEntity.message ?? "Unknown error"
        }
    }
}
