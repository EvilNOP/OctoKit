//
//  MultiTarget+Mutable.swift
//  OctoKit
//
//  Created by Matthew on 22/01/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya

extension MultiTarget: MutableType {
    
    public mutating func withParameters(_ parameters: [String : Any]?) {
        if var newTarget = target as? MutableType {
            newTarget.withParameters(parameters)
            
            self = .target(newTarget as! TargetType)
        }
    }
}
