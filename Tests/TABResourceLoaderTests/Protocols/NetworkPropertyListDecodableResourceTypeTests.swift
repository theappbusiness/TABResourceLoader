//
//  NetworkJSONDecodableResourceTypeTests.swift
//  TABResourceLoader
//
//  Created by Sam Dods on 10/10/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

struct MockNetworkJSONDecodableResourceType: NetworkJSONDecodableResourceType {
  typealias Model = String
  typealias Root = Model
  let url: URL
}

class NetworkJSONDecodableResourceTypeTests: XCTestCase {

  let url = URL(string: "www.test.com")!

  func test_correctDefaultValues() {
    let resource = MockNetworkJSONDecodableResourceType(url: url)
    XCTAssertEqual(resource.httpRequestMethod, HTTPMethod.get)
    XCTAssertEqual(resource.httpHeaderFields!, ["Content-Type": "application/json"])
    XCTAssertNil(resource.jsonBody)
    XCTAssertNil(resource.queryItems)
  }

}
