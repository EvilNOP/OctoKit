//
//  ReviewComment.swift
//  OctoKit
//
//  Created by Matthew on 31/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

/// A review comment is a comment that occurs on a portion of a
/// unified diff, such as a commit or a pull request. If the comment
/// refers to the entire entity, the path and position properties
/// will be nil.
protocol ReviewComment: Comment {
    
    /// The relative path of the file being commented on. This
    /// will be nil if the comment refers to the entire entity,
    /// not a specific path in the diff.
    var path: String? { get }
    
    /// The current HEAD SHA of the code being commented on.
    var commitSHA: String? { get }
    
    /// The line index of the code being commented on. This
    /// will be nil if the comment refers to the entire review
    /// entity (commit/pull request).
    var position: Int { get }
}
