//
//  Notification.swift
//  OctoKit
//
//  Created by Matthew on 03/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import ObjectMapper

/// A notification of some type of activity.
public class Notification: Object {
    
    /// The title of the notification.
    public internal(set) dynamic var title: String?
    
    /// The API URL to the notification's thread.
    public internal(set) dynamic var threadURLString: String?
    
    /// The API URL to the subject that the notification was generated for (e.g., the
    /// issue or pull request).
    public internal(set) dynamic var subjectURLString: String?
    
    /// The API URL to the latest comment in the thread.
    ///
    /// If the notification does not represent a comment, this will be the same as
    /// the subjectURL.
    public internal(set) dynamic var latestCommentURLString: String?
    
    /// The notification type.
    public internal(set) dynamic var type: String?
    
    /// The repository to which the notification belongs.
    public internal(set) dynamic var repository: Repository?
    
    /// The date on which the notification was last updated.
    public internal(set) dynamic var lastUpdatedDate: Date?
    
    /// Whether this notification has yet to be read.
    public internal(set) dynamic var isUnread: Bool = false
    
    // MARK: - Lifecycle
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    // MARK: - Mapping
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
//        let transform = TransformOf<NotificationType, String>(fromJSON: { value in
//            guard let typeJSON = value else {
//                return nil
//            }
//            
//            return NotificationType(rawValue: typeJSON)
//        }, toJSON: { value in
//            guard let type = value else {
//                return nil
//            }
//            
//            return type.rawValue
//        })
        
        title                  <- map["subject.title"]
        threadURLString        <- map["url"]
        subjectURLString       <- map["subject.url"]
        latestCommentURLString <- map["subject.latest_comment_url"]
        type                   <- map["subject.type"]
        repository             <- map["repository"]
        isUnread               <- map["unread"]
        lastUpdatedDate        <- (map["updated_at"], ISO8601DateTransform())
    }
}
