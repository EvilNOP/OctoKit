//
//  PageableType.swift
//  OctoKit
//
//  Created by Matthew on 01/06/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

/// The `PageableType` protocol defines pagination infomation.
public protocol PageableType {
    
    /// Validation each size of page within 1 to 100, if `perPgge` ouf of range, this function will
    /// return the default size 30.
    ///
    /// - parameter perPage: The size of the page to be validated.
    ///
    /// - returns: The size of page validated.
    func perPage(with perPage: Int) -> Int
    
    func page(with offset: Int, perPage: Int) -> Int
    
    func pageOffset(_ offset: Int, perPage: Int) -> Int
    
    func nextPageNumber(from response: HTTPURLResponse) -> Int?
    
    func nextPageURL(from response: HTTPURLResponse) -> URL?
}
