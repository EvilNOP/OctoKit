//
//  Comment.swift
//  OctoKit
//
//  Created by Matthew on 31/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

/// A comment can be added to an issue, pull request, or commit.
protocol Comment {
    
    /// The login of the user who created this comment.
    var commenterLogin: String? { get }
    
    /// The date at which the comment was originally created.
    var creationDate: Date? { get }
    
    /// The date the comment was last updated. This will be equal to
    /// creationDate if the comment has not been updated.
    var updatedDate: Date? { get }
    
    /// The body of the comment.
    var body: String? { get }
}
