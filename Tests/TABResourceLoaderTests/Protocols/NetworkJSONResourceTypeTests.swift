//
//  NetworkJSONResourceTypeTests.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 28/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

struct MockDefaultNetworkJSONResource: NetworkJSONResourceType {
  typealias Model = String
  let url: URL
}

class NetworkJSONResourceTypeTests: XCTestCase {

  let url = URL(string: "www.test.com")!

  func test_correctDefaultValues() {
    let resource = MockDefaultNetworkJSONResource(url: url)
    XCTAssertEqual(resource.httpRequestMethod, HTTPMethod.get)
    XCTAssertEqual(resource.httpHeaderFields!, ["Content-Type": "application/json"])
    XCTAssertNil(resource.jsonBody)
    XCTAssertNil(resource.queryItems)
  }

}
