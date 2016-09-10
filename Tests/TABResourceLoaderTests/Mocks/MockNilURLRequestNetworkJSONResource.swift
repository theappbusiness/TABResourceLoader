//
//  MockNilURLRequestNetworkJSONResource.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

struct MockNilURLRequestNetworkJSONResource: NetworkJSONResourceType {
  typealias Model = String
  let url: NSURL = NSURL(string: "www.test.com")!
  func urlRequest() -> NSURLRequest? {
    return nil
  }
}