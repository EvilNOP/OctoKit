//
//  RxPaginationProvider.swift
//  OctoKit
//
//  Created by Matthew on 01/06/2017.
//  Copyright © 2017 Matthew. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper

public class RxPaginationProvider<Target>: RxMoyaProvider<Target> where Target: TargetType {

    
}

// MARK: - Pagination

extension RxPaginationProvider: PageableType {
    
    public func perPage(with perPage: Int) -> Int {
        return 1...100 ~= perPage ? perPage : 30
    }
    
    public func page(with offset: Int, perPage: Int) -> Int {
        return offset / perPage + 1
    }
    
    public func pageOffset(_ offset: Int, perPage: Int) -> Int {
        return offset % perPage
    }
    
    public func nextPageURL(from response: HTTPURLResponse) -> URL? {
        if let linkHeader = response.allHeaderFields["Link"] as? String {
            /* looks like:
             <https://api.github.com/user/20267/gists?page=2>; rel="next",
             <https://api.github.com/user/20267/gists?page=6>; rel="last"
             */
            // so split on "," then on ";"
            let componets = linkHeader.characters.split { $0 == "," }.map { String($0) }
            
            // now we have 2 lines like
            // '<https://api.github.com/user/20267/gists?page=2>; rel="next"'
            // So let's get the URL out of there:
            for item in componets {
                // see if it's "next"
                let rangeOfNext = item.range(of: "rel=\"next\"")
                
                if rangeOfNext != nil {
                    let rangeOfPaddedURL = item.range(
                        of: "<(.*)>;", options: .regularExpression, range: nil, locale: nil
                    )
                    
                    if let range = rangeOfPaddedURL {
                        let nextURL = item.substring(with: range)
                        
                        // strip off the < and >;
                        let startIndex = nextURL.index(nextURL.startIndex, offsetBy: 1)
                        let endIndex = nextURL.index(nextURL.endIndex, offsetBy: -2)
                        let URLRange = startIndex..<endIndex
                        
                        return URL(string: nextURL.substring(with: URLRange))
                    }
                }
            }
        }
        
        return nil
    }
    
    public func nextPageNumber(from response: HTTPURLResponse) -> Int? {
        guard let nextPageURL = nextPageURL(from: response) else {
            return nil
        }
        
        let components = URLComponents(url: nextPageURL, resolvingAgainstBaseURL: false)
        
        if let pageNumberString = components?.queryValue(for: "page") {
            print("Page number: \(pageNumberString)")
            return Int(pageNumberString)
        }
        
        return nil
    }
}
