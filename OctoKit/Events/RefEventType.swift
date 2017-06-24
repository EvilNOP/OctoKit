//
//  RefEventType.swift
//  OctoKit
//
//  Created by Matthew on 20/02/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

/// The type of event that occurred around a reference.
public enum RefEventType: String {
    
    /// An unknown event occurred. Ref events will never be
    /// initialized with this value they will simply
    /// fail to be created.
    case unknown
    
    /// The reference was created on the server.
    case CreateEvent
    
    /// The reference was deleted on the server.
    case DeleteEvent
}
