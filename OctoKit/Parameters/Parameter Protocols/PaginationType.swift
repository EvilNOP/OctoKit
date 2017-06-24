//
//  PaginationType.swift
//  OctoKit
//
//  Created by Matthew on 13/06/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

protocol PaginationType {
    
    var page: Int? { get set }
    var perPage: Int? { get set }
}
