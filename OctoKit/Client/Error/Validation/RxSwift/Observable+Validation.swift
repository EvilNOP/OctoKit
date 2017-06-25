//
//  Observable+Validation.swift
//  OctoKit
//
//  Created by Matthew on 30/05/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya
import RxSwift

/// Extension for validating Responses and throw errors when validation fail.
extension ObservableType where E == Response {
    
    public func validate() -> Observable<E> {
        return flatMap { response -> Observable<E> in
            return Observable.just(try response.validate())
        }
    }
}
