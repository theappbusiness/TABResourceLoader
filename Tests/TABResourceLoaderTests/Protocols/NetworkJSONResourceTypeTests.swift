//
//  NetworkJSONResourceTypeTests.swift
//  TABResourceLoader
//
//  Created by John Sanderson on 30/01/2018.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 The App Business

import XCTest
@testable import TABResourceLoader

private struct MockNetworkJSONResourceType: NetworkJSONResourceType {

  typealias Model = String
  let url: URL
  let jsonBody: Any?

}

class NetworkJSONResourceTypeTests: XCTestCase {

  let url = URL(string: "www.test.com")!
  let expectedJSONBody: [String: Any] = ["testKey": "withATestValue",
                                     "anotherKey": "withAnotherValue"]

  func test_correctDefaultValues() {
    let resource = MockNetworkJSONResourceType(url: url, jsonBody: expectedJSONBody)
    let expectedJSONData = try? JSONSerialization.data(withJSONObject: expectedJSONBody, options: JSONSerialization.WritingOptions.prettyPrinted)
    XCTAssertEqual(resource.httpRequestMethod, HTTPMethod.get)
    XCTAssertEqual(resource.httpHeaderFields!, ["Content-Type": "application/json"])
    XCTAssertNil(resource.queryItems)
    XCTAssertEqual(resource.httpBody, expectedJSONData)

    let urlRequest = resource.urlRequest()
    XCTAssertNotNil(urlRequest)
    XCTAssertEqual(urlRequest!.httpBody, expectedJSONData)
  }

}
