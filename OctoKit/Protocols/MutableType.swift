//
//  MutableType.swift
//  OctoKit
//
//  Created by Matthew on 20/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation

public protocol MutableType {

    mutating func withParameters(_ parameters: [String : Any]?)
}
