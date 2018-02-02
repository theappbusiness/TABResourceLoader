//
//  NetworkFormDataResourceTypeTests.swift
//  TABResourceLoader
//
//  Created by John Sanderson on 30/01/2018.
//  Copyright © 2018 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

struct MockNetworkFormDataResourceType: NetworkFormDataResourceType {

  typealias Model = String
  let url: URL
  let formDataBody: [String: Any]?

  func model(from data: Data) throws -> String {
    return ""
  }

}

class NetworkFormDataResourceTypeTests: XCTestCase {

  let url = URL(string: "www.test.com")!
  let expectedData: [String: Any] = ["testKey": "withATestValue",
                                         "anotherKey": "withAnotherValue"]

  func test_correctDefaultValues() {
    let resource = MockNetworkFormDataResourceType(url: url, formDataBody: expectedData)
    let expectedFormData = expectedData.formDataPostString.data(using: .utf8)
    XCTAssertEqual(resource.httpRequestMethod, HTTPMethod.post)
    XCTAssertEqual(resource.httpHeaderFields!, ["Content-Type": "application/x-www-form-urlencoded"])
    XCTAssertNil(resource.queryItems)
    XCTAssertEqual(resource.bodyData, expectedFormData)

    let urlRequest = resource.urlRequest()
    XCTAssertNotNil(urlRequest)
    XCTAssertEqual(urlRequest!.httpBody, expectedFormData)
  }

}
