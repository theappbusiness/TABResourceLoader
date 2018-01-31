//
//  NetworkJSONArrayResourceTypeTests.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 03/10/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

struct MockNetworkJSONArrayResourceType: NetworkJSONArrayResourceType {
  typealias Model = String
  let url: URL

  func model(from jsonArray: [Any]) throws -> String {
    return ""
  }

}

class NetworkJSONArrayResourceTypeTests: XCTestCase {

  let url = URL(string: "www.test.com")!

  func test_correctDefaultValues() {
    let resource = MockNetworkJSONArrayResourceType(url: url)
    XCTAssertEqual(resource.httpRequestMethod, HTTPMethod.get)
    XCTAssertEqual(resource.httpHeaderFields!, ["Content-Type": "application/json"])
    XCTAssertNil(resource.jsonBody)
    XCTAssertNil(resource.queryItems)
  }

}
