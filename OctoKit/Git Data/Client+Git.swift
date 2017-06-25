//
//  Client+Git.swift
//  OctoKit
//
//  Created by Matthew on 20/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya
import RxSwift

/// The types of content encodings.
public enum ContentEncoding: String {
    
    case utf8
    
    case base64
}

public extension Client {
    
    // MARK: - Client + Git
    
    /// Fetches the tree for the given reference.
    ///
    /// - parameter reference:   The SHA, branch, reference, or tag to fetch. May be nil, in
    ///                          which case HEAD is fetched.
    ///
    /// - parameter repository:  The repository from which the tree should be fetched. Cannot be
    ///                          nil.
    ///
    /// - parameter isRecursive:  the tree be fetched recursively.
    ///
    /// - returns: A signal which will send an Tree and complete or error.
    public func fetchTree(for reference: String? = nil, in repository: Repository,
                          isRecursive: Bool = false) -> Observable<Tree> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        var parameter = GitParameter(
            login: login,
            repositoryName: repositoryName,
            SHA: reference ?? "HEAD"
        )
        
        if isRecursive {
            parameter.isRecursive = 1
        }
        
        return provider.request(
            MultiTarget(GitRouter.singleTree(parameter))
        ).validate().mapObject(Tree.self)
    }
    
    /// Creates a new tree.
    ///
    /// - parameter treeEntries: The `TreeEntry` objects that should comprise the new tree.
    ///
    /// - parameter repository:  The repository in which to create the tree. Cannot be nil.
    ///
    /// - parameter baseTreeSHA: The SHA of the tree upon which to base this new tree. This may
    ///                          be nil to create an orphaned tree.
    ///
    /// - returns: A signal which will send the created Tree and complete, or error.
    public func createTree(with treeEntries: [TreeEntry], in repository: Repository,
                           baseTreeSHA: String? = nil) -> Observable<Tree> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        var parameter = GitParameter(login: login, repositoryName: repositoryName)
        
        parameter.treeEntries = treeEntries
        parameter.baseTreeSHA = baseTreeSHA
        
        return provider.request(MultiTarget(GitRouter.createTree(parameter))).validate().mapObject(Tree.self)
    }
    
    /// Fetches the blob identified by the given SHA.
    ///
    /// - parameter SHA:        The SHA of the blob to fetch. This must not be nil.
    ///
    /// - parameter repository: The repository from which the blob should be fetched. Cannot be
    ///                         nil.
    ///
    /// - returns: A signal which will send an `Blob` then complete, or error.
    public func fetchBlob(with SHA: String, in repository: Repository) -> Observable<Blob> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        let parameter = GitParameter(login: login, repositoryName: repositoryName, SHA: SHA)
        
        return provider.request(
            MultiTarget(GitRouter.singleBlob(parameter))
        ).validate().mapObject(Blob.self)
    }
    
    /// Creates a blob using the given text content and encoding
    ///
    /// - parameter content:    The text for the new blob. This must not be nil.
    ///
    /// - parameter repository: The repository in which to create the blob. This must not be
    ///                         nil.
    ///
    /// - parameter encoding:   The encoding of the text. utf-8 or base64, must not be nil.
    ///
    /// - returns: A signal which will send an `Blob` then complete, or error.
    public func createBlob(with content: String, in repository: Repository,
                           encoding: ContentEncoding = .utf8) -> Observable<Blob> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        var parameter = GitParameter(login: login, repositoryName: repositoryName)
        
        parameter.content = content
        parameter.encoding = encoding == .utf8 ? "utf-8" : "base64"
        
        return provider.request(MultiTarget(GitRouter.createBlob(parameter))).validate().mapObject(Blob.self)
    }
    
    /// Fetches the commit identified by the given SHA.
    ///
    /// - parameter SHA:        The SHA of the commit to fetch. This must not be nil.
    ///
    /// - parameter repository: The repository from which the commit should be fetched. Cannot be
    ///                         nil.
    ///
    /// - returns: A signal which will send an `Commit` then complete, or error.
    public func fetchCommit(with SHA: String, in repository: Repository) -> Observable<Commit> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        let parameter = GitParameter(login: login, repositoryName: repositoryName, SHA: SHA)
        
        return provider.request(
            MultiTarget(GitRouter.singleCommit(parameter))
        ).validate().mapObject(Commit.self)
    }
    
    /// Creates a commit.
    ///
    /// - parameter message:    The message of the new commit. This must not be nil.
    ///
    /// - parameter repository: The repository in which to create the commit. This must not be
    ///                         nil.
    ///
    /// - parameter treeSHA:    The SHA of the tree for the new commit. This must not be nil.
    ///
    /// - parameter parentSHAs: An array of `String`s representing the SHAs of parent commits
    ///                         for the new commit. This can be empty to create a root commit,
    ///                         or have more than one object to create a merge commit. This
    ///                         array must not be nil.
    ///
    /// - returns: A signal which will send the created `Commit` then complete, or
    ///            error.
    public func createCommit(with message: String, in repository: Repository,
                             treeSHA: String, parentSHAs: [String]) -> Observable<Commit> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        var parameter = GitParameter(login: login, repositoryName: repositoryName)
        
        parameter.message = message
        parameter.treeSHA = treeSHA
        parameter.parentSHAs = parentSHAs
        
        return provider.request(
            MultiTarget(GitRouter.createCommit(parameter))
        ).mapObject(Commit.self)
    }
    
    /// Fetches all references in the given repository.
    ///
    /// - parameter repository: The repository in which to fetch the references. This must not be nil.
    ///
    /// - returns: A signal which sends zero or more Ref objects then complete, or error.
    public func fetchAllReferences(in repository: Repository,
                                   fetchAllPages: Bool = false) -> Observable<Ref> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        let parameter = GitParameter(login: login, repositoryName: repositoryName)
        
        return provider.request(
            MultiTarget(GitRouter.allReferences(parameter)), fetchAllPages: fetchAllPages
        )
    }
    
    /// Fetches a git reference given its fully-qualified name.
    ///
    /// - parameter refName:    The fully-qualified name of the ref to fetch (e.g.,
    ///                         `heads/master`). This must not be nil.
    ///
    /// - parameter repository: The repository in which to fetch the ref. This must not be nil.
    ///
    /// - returns: A signal which will send an Ref then complete, or error.
    public func fetchReference(with refName: String, in repository: Repository) -> Observable<Ref> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        let parameter = GitParameter(login: login, repositoryName: repositoryName, ref: refName)
        
        return provider.request(
            MultiTarget(GitRouter.singleReference(parameter))
        ).validate().mapObject(Ref.self)
    }
    
    /// Attempts to update a reference to point at a new SHA.
    ///
    /// - parameter refName:    The fully-qualified name of the ref to update (e.g.,
    ///                         `heads/master`). This must not be nil.
    ///
    /// - parameter repository: The repository in which to update the ref. This must not be nil.
    ///
    /// - parameter newSHA:     The new SHA for the ref. This must not be nil.
    ///
    /// - parameter isForced:   Whether to force the ref to update, even if it cannot be
    ///                         fast-forwarded.
    ///
    /// - returns: A signal which will send the updated Ref then complete, or error.
    public func updateReference(with refName: String, in repository: Repository,
                                newSHA: String, isForced: Bool) -> Observable<Ref> {
        guard let login = repository.ownerLogin, let repositoryName = repository.name else {
            fatalError("`repository.name` or `repository.ownerLogin` must not be nil.")
        }
        
        var parameter = GitParameter(login: login, repositoryName: repositoryName, ref: refName)
        
        parameter.newSHA = newSHA
        parameter.isForced = isForced
        
        return provider.request(
            MultiTarget(GitRouter.updateReference(parameter))
        ).validate().mapObject(Ref.self)
    }
}
