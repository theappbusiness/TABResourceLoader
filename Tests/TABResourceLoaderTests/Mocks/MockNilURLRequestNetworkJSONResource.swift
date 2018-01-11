//
//  MockNilURLRequestNetworkJSONResource.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

struct MockNilURLRequestNetworkJSONResource: NetworkDataResourceType {
  typealias Model = String
  let url: URL = URL(string: "www.test.com")!

  func urlRequest(with: [URLQueryItem]) -> URLRequest? {
    return nil
  }

  func model(from data: Data) throws -> String {
    return ""
  }

}
