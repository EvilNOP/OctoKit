//
//  Client+Authentication.swift
//  OctoKit
//
//  Created by Matthew on 08/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya
import RxSwift

extension Client {
    
    /// Notifies any waiting login processes that authentication has completed.
    ///
    /// This only affects authentication started with
    /// signIn:scopes:. Invoking this method will allow
    /// the originating login process to continue. If `callbackURL` does not
    /// correspond to any in-progress logins, nothing will happen.
    ///
    /// - parameter callbackURL: The URL that the app was opened with. This must not be nil.
    public class func completeSignIn(with callbackURL: URL) {
        callbackURLSubject.onNext(callbackURL)
    }
    
    class func authorize(with scopes: ClientAuthorizationScopes) -> Observable<String> {
        return Observable<String>.create { observer in
            let uuidString = UUID().uuidString
            
            // For any matching callback URL, send the temporary code to our
            // subscriber.
            //
            // This should be set up before opening the URL below, or we may
            // miss values on self.callbackURLs.
            let callbackDisposable = self.callbackURLSubject.map { callbackURL -> String in
                var oauthCode = ""
                
                let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)
                
                if let state = components?.queryValue(for: "state"), state == uuidString {
                    if let code = components?.queryValue(for: "code") {
                        oauthCode = code
                    }
                }
                
                return oauthCode
            }.take(1).subscribe(observer)
            
            let scope = scopesArray(scopes).joined(separator: ",")
            
            let identity = AuthenticationRouter.identity
            
            let baseOAuthURL = identity.baseURL.appendingPathComponent(identity.path).absoluteString
            
            let URLString = "\(baseOAuthURL)?client_id=\(clientID)&scope=\(scope)&state=\(uuidString)"
            
            let url = URL(string: URLString)!
            
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions.
                    UIApplication.shared.openURL(url)
                }
            }
            
            return Disposables.create([callbackDisposable])
        }
    }
    
    /// Attempts to authenticate as the given user.
    ///
    /// Authentication is done using a native OAuth flow. This allows apps to avoid
    /// presenting a webpage, while minimizing the amount of time the client app
    /// needs the user's password.
    ///
    /// If `user` has two-factor authentication turned on and `oneTimePassword` is
    /// not provided, the authorization will be rejected with an error whose `code` is
    /// `ClientErrorTwoFactorAuthenticationOneTimePasswordRequired`. The behavior
    /// then depends on the `ClientOneTimePasswordMedium` that the user has set:
    ///
    ///  * If the user has chosen SMS as their authentication method, they will be
    ///    sent a one-time password _each time_ this method is invoked.
    ///  * If the user has chosen to use an app for authentication, they must open
    ///    their chosen app and use the one-time password it presents.
    ///
    /// You can then invoke this method again to request authorization using the
    /// one-time password entered by the user.
    ///
    /// **NOTE:** You must invoke setClientID:clientSecret: before using this
    /// method.
    ///
    /// - parameter user:            The user to authenticate as. The `user` property of the
    ///                              returned client will be set to this object. This must not be nil.
    ///
    /// - parameter password:        The user's password. Cannot be nil.
    ///
    /// - parameter oneTimePassword: The one-time password to approve the authorization request.
    ///                              This may be nil if you have no one-time password to
    ///                              provide, which will usually be the case unless you've
    ///                              already requested authorization, `user` has two-factor
    ///                              authentication on, and the user has entered their one-time
    ///                              password.
    ///
    /// - parameter scopes:          The scopes to request access to. These values can be
    ///                              bitwise OR'd together to request multiple scopes.
    ///
    /// - parameter note:            A human-readable string to remind the user what this OAuth
    ///                              token is used for. May be nil.
    ///
    /// - parameter noteURL:         A URL to remind the user what the OAuth token is used for.
    ///                              May be nil.
    ///
    /// - parameter fingerprint:     A unique string to distinguish one authorization from
    ///                              others created for the same client ID and user. May be nil.
    ///
    /// - returns: A signal which will send an Client then complete on success, or
    ///            else error. If the server is too old to support this request, an error will
    ///            be sent with code `ClientErrorUnsupportedServer`.
    public class func signInAsUser(_ user: User, password: String, oneTimePassword: String? = nil,
                                   scopes: ClientAuthorizationScopes,
                                   note: String? = nil, noteURL: URL? = nil,
                                   fingerprint: String? = nil) -> Observable<Client> {
        guard !clientID.isEmpty, !clientSecret.isEmpty else {
            fatalError(
                "`clientID` and `clientSecret` must be set before calling" +
                " Client.signInAsUser(_:password:oneTimePassword:scopes:note:noteURL:fingerprint:)"
            )
        }
        
        var parameter = AuthenticationParameter()
        
        parameter.clientID = clientID
        parameter.clientSecret = clientSecret
        parameter.oneTimePassword = oneTimePassword
        parameter.scopes = scopesArray(scopes)
        parameter.note = note
        parameter.noteURL = noteURL?.absoluteString
        parameter.fingerprint = fingerprint
        
        configureAuthProvider(with: (user.rawLogin ?? "", password))
        
        return authProvider.request(
            .getOrCreateAuthorization(parameter)
        ).flatMap { response -> Observable<Authorization> in
            do {
                let authorization = try response.mapObject(Authorization.self)
                
                if let token = authorization.token {
                    // To increase security, tokens are no longer returned when the authorization
                    // already exists. If that happens, we need to delete the existing
                    // authorization for this app and create a new one, so we end up with a token
                    // of our own.
                    //
                    // The `fingerprint` field provided will be used to ensure uniqueness and
                    // avoid deleting unrelated tokens.
                    if token.isEmpty && response.statusCode == 200 {
                        deleteAuthorization(with: authorization.id)
                        
                        return authProvider.request(
                            .getOrCreateAuthorization(parameter)
                        ).mapObject(Authorization.self)
                    } else {
                        return Observable.just(authorization)
                    }
                }
            } catch let error {
                return Observable.error(error)
            }
            
            return Observable.error(MoyaError.jsonMapping(response))
        }.map { authorization in
            Client(user: user, token: authorization.token ?? "")
        }
    }
    
    /// Opens the default web browser to the given GitHub server, and prompts the
    /// user to sign in.
    ///
    /// Your app must be the preferred application for handling its URL callback, as set
    /// in your OAuth Application Settings). When the callback URL is opened using
    /// your app, you must invoke completeSignIn: in order for this
    /// authentication method to complete successfully.
    ///
    /// **NOTE:** You must set clientID and clientSecret before using this
    /// method.
    ///
    /// - parameter server: The server that the user should sign in to. This must not be
    ///                     nil.
    ///
    /// - parameter scopes: The scopes to request access to. These values can be
    ///                     bitwise OR'd together to request multiple scopes.
    ///
    /// - returns: A signal which will send an Client then complete on success, or
    ///            else error. If completeSignIn: is never invoked, the returned
    ///            signal will never complete.
    public class func signInToServer(_ server: Server,
                                     scopes: ClientAuthorizationScopes) -> Observable<Client> {
        if clientID.isEmpty || clientSecret.isEmpty {
            fatalError(
                "`clientID` and `clientSecret` must be set before calling" +
                " Client.signInToServer(_:scopes:)"
            )
        }
        
        configureAuthProvider()
        
        let client = Observable.just(Client(server: server))
        
        let accessToken = authorize(with: scopes).flatMap { oauthCode in
            exchangeOAuthCodeForToken(oauthCode)
        }
        
        return Observable.combineLatest(client, accessToken) { (client, accessToken) -> Client in
            client.token = accessToken.token ?? ""
            
            return client
        }.flatMap { client in
            client.fetchUserInformation().map { user -> (Client) in
                client.user = user
                
                return client
            }
        }
    }
    
    private class func deleteAuthorization(with id: Int) {
        authProvider.request(.deleteAuthorization(AuthenticationParameter(identity: id))) { result in
            switch result {
            case .success(let response):
                if response.statusCode != 204 {
                    print("Failed to delete an authorization.")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private class func exchangeOAuthCodeForToken(_ oauthCode: String) -> Observable<AccessToken> {
        var parameter = AuthenticationParameter()
        
        parameter.clientID = clientID
        parameter.clientSecret = clientSecret
        parameter.oauthCode = oauthCode
        
        return authProvider.request(
            .exchangeCodeForAccessToken(parameter)
        ).validate().mapObject(AccessToken.self)
    }
    
    private class func scopesArray(_ scopes: ClientAuthorizationScopes) -> [String] {
        let scopeToScopeString = [
            ClientAuthorizationScopes.publicReadOnly.rawValue   : "",
            ClientAuthorizationScopes.userEmail.rawValue        : "user:email",
            ClientAuthorizationScopes.userFollow.rawValue       : "user:follow",
            ClientAuthorizationScopes.user.rawValue             : "user",
            ClientAuthorizationScopes.repositoryStatus.rawValue : "repo:status",
            ClientAuthorizationScopes.publicRepository.rawValue : "public_repo",
            ClientAuthorizationScopes.repository.rawValue       : "repo",
            ClientAuthorizationScopes.repositoryDelete.rawValue : "delete_repo",
            ClientAuthorizationScopes.notifications.rawValue    : "notifications",
            ClientAuthorizationScopes.gist.rawValue             : "gist",
            ClientAuthorizationScopes.publicKeyRead.rawValue    : "read:public_key",
            ClientAuthorizationScopes.publicKeyWrite.rawValue   : "write:public_key",
            ClientAuthorizationScopes.publicKeyAdmin.rawValue   : "admin:public_key",
            ClientAuthorizationScopes.orgRead.rawValue          : "read:org"
        ]
        
        return scopeToScopeString.filter { scope, _ in
            scopes.rawValue & scope != 0
        }.map { (scope, _) in
            scopeToScopeString[scope]!
        }.filter { scopeString in
            scopeString.characters.count > 0
        }
    }
    
    private class func configureAuthProvider(with credential: BasicAuthPlugin.Credential? = nil) {
        // Configure session manager.
        let configuration = URLSessionConfiguration.default
        
        var headers = Manager.defaultHTTPHeaders
        
        headers["User-Agent"] = Client.userAgent
        
        configuration.httpAdditionalHeaders = headers
        
        let sessionManager = Manager(configuration: configuration)
        
        var plugins: [PluginType] = []
        
        if let credential = credential {
            // Authenticate `.getOrCreateAuthorization` or `.delete` request only.
            let basicAuthPlugin = BasicAuthPlugin { target -> BasicAuthPlugin.Credential? in
                guard let authenticationRouter = target as? AuthenticationRouter else {
                    return nil
                }
                
                switch authenticationRouter {
                case .getOrCreateAuthorization, .deleteAuthorization:
                    return (credential.username, credential.password)
                default:
                    return nil
                }
            }
            
            plugins.append(basicAuthPlugin)
        }
        
        let contentTypePlugin = ContentTypePlugin { target -> ContentTypePlugin.ContentType? in
            guard let authenticationRouter = target as? AuthenticationRouter else {
                return nil
            }
            
            switch authenticationRouter {
            case .exchangeCodeForAccessToken:
                return "application/json"
            default:
                return StableContentType
            }
        }
        
        plugins.append(contentTypePlugin)
        
        authProvider = RxMoyaProvider<AuthenticationRouter>(manager: sessionManager, plugins: plugins)
    }
}
