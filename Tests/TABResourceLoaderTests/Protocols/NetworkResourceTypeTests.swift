//
//  NetworkResourceTypeTests.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

private struct MockDefaultNetworkResource: NetworkResourceType {
  typealias Model = String
  let url: URL
}

private struct MockCustomNetworkResource: NetworkResourceType {
  typealias Model = String
  let url: URL
  let HTTPRequestMethod: HTTPMethod
  let HTTPHeaderFields: [String: String]?
  let JSONBody: Any?
  let queryItems: [URLQueryItem]?

  init(url: URL, HTTPRequestMethod: HTTPMethod = .get, HTTPHeaderFields: [String : String]? = nil, JSONBody: Any? = nil, queryItems: [URLQueryItem]? = nil) {
    self.url = url
    self.HTTPRequestMethod = HTTPRequestMethod
    self.HTTPHeaderFields = HTTPHeaderFields
    self.JSONBody = JSONBody
    self.queryItems = queryItems
  }
}

class NetworkResourceTypeTests: XCTestCase {
  
  let url = URL(string: "www.test.com")!
  let urlWithQueryItem = URL(string: "www.test.com?query-name=query-value")!

  func test_correctDefaultValues() {
    let resource = MockDefaultNetworkResource(url: url)
    XCTAssertEqual(resource.HTTPRequestMethod, HTTPMethod.get)
    XCTAssertEqual(resource.HTTPHeaderFields!, [:])
    XCTAssertNil(resource.JSONBody)
    XCTAssertNil(resource.queryItems)
  }

  func test_urlRequest_allProperties() {
    let expectedHTTPMethod = HTTPMethod.post
    let expectedAllHTTPHeaderFields = ["key": "value"]
    let expectedJSONBody = ["jsonKey": "jsonValue"]
    let mockedURLQueryItems = [URLQueryItem(name: "query-name", value: "query-value")]
    let expectedURL = "\(url)?query-name=query-value"
    let mockNetworkResource = MockCustomNetworkResource(url: url, HTTPRequestMethod: expectedHTTPMethod, HTTPHeaderFields: expectedAllHTTPHeaderFields, JSONBody: expectedJSONBody, queryItems: mockedURLQueryItems)

    let urlRequest = mockNetworkResource.urlRequest()
    XCTAssertNotNil(urlRequest)
    XCTAssertEqual(urlRequest?.url?.absoluteString, expectedURL)
    XCTAssertEqual(urlRequest?.httpMethod, expectedHTTPMethod.rawValue)
    XCTAssertEqual(urlRequest!.allHTTPHeaderFields!, expectedAllHTTPHeaderFields)
    let expectedJSONData = try! JSONSerialization.data(withJSONObject: expectedJSONBody, options: JSONSerialization.WritingOptions.prettyPrinted)
    XCTAssertEqual(urlRequest!.httpBody!, expectedJSONData)
  }

  func test_urlRequest_resourceURLWithQueryParameters() {
    let urlWithQueryParameters = URL(string: "www.test.com?query-name=query-value")!
    let resource = MockCustomNetworkResource(url: urlWithQueryParameters)

    let urlRequest = resource.urlRequest()
    XCTAssertEqual(urlRequest?.url?.absoluteString, urlWithQueryParameters.absoluteString)
  }

  func test_urlRequest_resourceURLWithQueryParametersAndQueryItems() {
    let mockedURLQueryItems = [URLQueryItem(name: "query-name-a", value: "query-value-a")]
    let resource = MockCustomNetworkResource(url: urlWithQueryItem, queryItems: mockedURLQueryItems)

    let expectedURLString = "\(urlWithQueryItem)&query-name-a=query-value-a"
    let urlRequest = resource.urlRequest()
    XCTAssertEqual(urlRequest?.url?.absoluteString, expectedURLString)
  }

  func test_urlRequest_sameResourceURLWithQueryParametersAndQueryItems() {
    let mockedURLQueryItems = [URLQueryItem(name: "query-name", value: "query-value-a")]
    let resource = MockCustomNetworkResource(url: urlWithQueryItem, queryItems: mockedURLQueryItems)

    let expectedURLString = "\(urlWithQueryItem)&query-name=query-value-a"
    let urlRequest = resource.urlRequest()
    XCTAssertEqual(urlRequest?.url?.absoluteString, expectedURLString)
  }

}
