//
//  MockNetworkJSONResource.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

struct MockDefaultNetworkJSONResource: NetworkJSONResourceType {
  typealias Model = String
  let url: NSURL

  init(url: NSURL) {
    self.url = url
  }
}


struct MockNetworkJSONResource: NetworkJSONResourceType {
  typealias Model = String

  let url: NSURL
  let HTTPRequestMethod: HTTPMethod
  let HTTPHeaderFields: [String: String]?
  let JSONBody: AnyObject?
  let queryItems: [NSURLQueryItem]?

  init(url: NSURL, HTTPRequestMethod: HTTPMethod = .GET, HTTPHeaderFields: [String : String]? = nil, JSONBody: AnyObject? = nil, queryItems: [NSURLQueryItem]? = nil) {
    self.url = url
    self.HTTPRequestMethod = HTTPRequestMethod
    self.HTTPHeaderFields = HTTPHeaderFields
    self.JSONBody = JSONBody
    self.queryItems = queryItems
  }
  
}
