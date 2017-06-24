//
//  Client.swift
//  OctoKit
//
//  Created by Matthew on 28/12/2016.
//  Copyright © 2016 Matthew. All rights reserved.
//

import Foundation
import Moya
import Result
import RxSwift
import Moya_ObjectMapper

/// An environment variable that, when present, will enable logging of all
/// responses.
let ClientResponseLoggingEnvironmentKey = "LOG_API_RESPONSES"

let StableContentType = "application/vnd.github.v3+json"

let ClientNotModifiedStatusCode = 304

/// The default URL scheme to use for Enterprise URLs, if none is explicitly
/// known or specified.
/// Enterprise defaults to HTTP, and not all instances have HTTPS set up.
let ServerDefaultEnterpriseScheme = "http"

/// The HTTPS URL scheme to use for Enterprise URLs.
/// Expose Enterprise HTTPS scheme for clients.
let ServerHTTPSEnterpriseScheme = "https"

/// The full URL String for the github.com homepage
let ServerDotComBaseWebURL = "https://github.com"

/// The full URL String for the github.com API
let ServerDotComAPIEndpoint = "https://api.github.com"

/// The path to the API for an Enterprise instance
/// (relative to the baseURL).
let ServerEnterpriseAPIEndpointPathComponent = "api/v3"

let ClientOneTimePasswordHeaderField = "X-GitHub-OTP"

/// Represents a single GitHub session.
///
/// Most of the methods on this class return a Signal representing a request
/// made to the API. The returned signal will deliver its results on a background
/// RACScheduler.
///
/// To avoid hitting the network for a result that won't be used, **no request
/// will be sent until the returned signal is subscribed to.** To cancel an
/// in-flight request, simply dispose of all subscriptions.
///
/// For more information about the behavior of requests, see
/// -enqueueRequestWithMethod:path:parameters:resultClass: and
/// -enqueueConditionalRequestWithMethod:path:parameters:notMatchingEtag:resultClass:,
/// upon which all the other request methods are built.
public class Client {
    
    // MARK: - Static Properties
    
    /// Sets the HTTP User-Agent for the current app. This will have no effect on any
    /// clients that have already been created.
    ///
    /// This method is thread-safe.
    ///
    /// The user agent to set. This must not be nil.
    static public var userAgent: String = "OctoKit"
    
    /// The OAuth client ID for your application. This must not be nil.
    static public var clientID: String = ""
    
    /// The OAuth client secret for your application. This must not be nil.
    static public var clientSecret: String = ""

    static var authProvider: RxMoyaProvider<AuthenticationRouter>!
    
    /// A publish subject to send callback URLs to after they're received by the app.
    static let callbackURLSubject = PublishSubject<URL>()
    
    // MARK: - Instance Properties
    
    /// The OAuth access token that the client was initialized with.
    ///
    /// You should protect this token like a password. **Never** save it to disk in
    /// plaintext — use the keychain instead.
    ///
    /// This will be `empty` when the client is created using
    /// unauthenticatedClientWithUser:
    public internal(set) var token: String
    
    /// The active user for this session.
    ///
    /// This may be set regardless of whether the session is authenticated or
    /// unauthenticated, and will control which username is used for endpoints
    /// that require one. For example, this user's login will be used with
    /// fetchUserEventsNotMatchingEtag:.
    public internal(set) var user: User?
    
    public internal(set) var server: Server
    
    /// All API requests through a MoyaProvider instance, passing in a value of your enum that
    /// specifies which endpoint you want to call.
    lazy var provider: RxPaginationProvider<MultiTarget> = {
        let (endpointClosure, requestClosure) = self.mapping()
        
        let configuration = URLSessionConfiguration.default
        
        var headers = Manager.defaultHTTPHeaders
        
        headers["User-Agent"] = userAgent
        
        configuration.httpAdditionalHeaders = headers
        
        let manager = Manager(configuration: configuration)
        
        let contentTypePlugin = ContentTypePlugin { target -> ContentTypePlugin.ContentType? in
            if let repositoryRouter = (target as! MultiTarget).target as? RepositoriesRouter {
                switch repositoryRouter {
                case .README:
                    return "application/vnd.github.VERSION.html"
                default:
                    return nil
                }
            }
            
            return nil
        }
        
        return RxPaginationProvider<MultiTarget>(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            manager: manager,
            plugins: [OAuthPlugin(token: self.token), contentTypePlugin]
        )
    }()
    
    // MARK: - Computed Properties
    
    /// Whether the current app is authenticated.
    public var isAuthenticated: Bool {
        return !token.isEmpty
    }
    
    // MARK: - Lifecycle
    
    /// Initializes the receiver to make requests to the given GitHub server.
    ///
    /// When using this initializer, the `user` property will not be set.
    /// init(user:token:) or init(user:) should typically be used instead.
    ///
    /// - parameter server: The GitHub server to connect to. This argument must not be nil.
    ///
    /// This is the designated initializer for this class.
    public init(server: Server) {
        self.server = server
        
        self.token = ""
    }
    
    /// Creates a client which can access any endpoints that don't require
    /// authentication.
    ///
    /// - parameter user: The active user. The `user` property of the returned client will be
    ///                   set to this object. This must not be nil.
    convenience public init(user: User) {
        self.init(server: user.server)
        
        self.user = user
    }
    
    /// Creates a client which will authenticate as the given user, using the given
    /// OAuth token.
    ///
    /// This method does not actually perform a login or make a request to the
    /// server. It only saves authentication information for future requests.
    ///
    /// - parameter user:  The user to authenticate as. The `user` property of the returned
    ///                    client will be set to this object. This must not be nil.
    /// - parameter token: An OAuth token for the given user. This must not be nil.
    /// - returns: A new client.
    convenience public init(user: User, token: String) {
        self.init(server: user.server)
        
        self.user = user
        self.token = token
    }
    
    // MARK: - Session Manager
    
    class func sessionManager(with contentType: String? = nil) -> Manager {
        let configuration = URLSessionConfiguration.default
        
        var headers = Manager.defaultHTTPHeaders
        
        headers["User-Agent"] = userAgent
        headers["Accept"] = contentType ?? StableContentType
        
        configuration.httpAdditionalHeaders = headers
        
        return Manager(configuration: configuration)
    }
}

// MARK: - Moya Provider Enpoint Mapping
extension Client {
    
    fileprivate func mapping() -> (MoyaProvider<MultiTarget>.EndpointClosure, MoyaProvider<MultiTarget>.RequestClosure) {
        let endpointClosure = { (target: MultiTarget) -> Endpoint<MultiTarget> in
            var endpoint = MoyaProvider.defaultEndpointMapping(for: target)
            
            if target.method == .get {
                if target.parameters == nil || !target.parameters!.keys.contains("per_page") {
                    endpoint = endpoint.adding(newParameters: ["per_page" : 100])
                }
            }
            
            // If an etag is specified, we want 304 responses to be treated as 304s,
            // not served from URLCache with a status of 200.
            if let etag =  target.parameters?["etag"] as? String {
                // Remove the `etag` parameter.
                
                
                return endpoint.adding(newHTTPHeaderFields: ["If-None-Match" : etag])
            }
            
            return endpoint
        }
        
        let requestClosure = {
            (endpoint: Endpoint<MultiTarget>, done: MoyaProvider.RequestResultClosure) in
            
            guard var request = endpoint.urlRequest else {
                done(.failure(Moya.MoyaError.requestMapping("Request mapping error!")))
                
                return
            }
            
            request.cachePolicy = .reloadIgnoringLocalCacheData
            
            done(.success(request))
        }
        
        return (endpointClosure, requestClosure)
    }
}
