//
//  SubclassedNetworkDataResourceServiceTests.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

private let commonKey = "common"
private let resourceNameKey = "resourceName"
private let mockResourceName = "Mock"
private let queryKey = "query"
private let mockQuery = "example"

protocol MockResourceType: NetworkResourceType, DataResourceType {
  var resourceName: String { get }
}

struct MockHTTPHeaderFieldsNetworkDataResource: MockResourceType {
  typealias Model = String
  let url: URL
  let httpHeaderFields: [String: String]?
  let resourceName = mockResourceName
  
  var queryItems: [URLQueryItem]? {
    return [URLQueryItem(name: queryKey, value: mockQuery)]
  }

  func model(from data: Data) throws -> String {
    return ""
  }
}

final class SubclassedNetworkDataResourceService<Resource: MockResourceType>: GenericNetworkDataResourceService<Resource> {

  required init() {
    super.init()
  }

  override init(session: URLSessionType) {
    super.init(session: session)
  }

  override func additionalHeaderFields<Resource: MockResourceType>(for resource: Resource) -> [String: String] {
    return [
      commonKey: "subclass",
      resourceNameKey: mockResourceName,
    ]
  }
  
  override func additionalQueryParameters<Resource>(for resource: Resource) -> [URLQueryItem] where Resource : DataResourceType, Resource : NetworkResourceType {
    return [URLQueryItem(name: resourceNameKey, value: mockResourceName)]
  }
}

class SubclassedNetworkJSONResourceServiceTests: XCTestCase { //swiftlint:disable:this type_name

  var testService: SubclassedNetworkDataResourceService<MockHTTPHeaderFieldsNetworkDataResource>!

  var mockSession: MockURLSession!
  var mockResource: MockHTTPHeaderFieldsNetworkDataResource!
  let mockURL = URL(string: "http://test.com")!

  override func setUp() {
    super.setUp()
    mockSession = MockURLSession()
    testService = SubclassedNetworkDataResourceService(session: mockSession)
  }

  func test_subclassHTTPHeaderFields_areOverridenByResourceHTTPHeaderFields() {
    let resourceHTTPHeaderFields = [commonKey: "resource"]
    mockResource = MockHTTPHeaderFieldsNetworkDataResource(url: mockURL, httpHeaderFields: resourceHTTPHeaderFields)
    testService.fetch(resource: mockResource) { _ in }
    let expectedHeaderFields = [commonKey: "resource", resourceNameKey: mockResourceName]
    XCTAssertEqual(mockSession.capturedRequest!.allHTTPHeaderFields!, expectedHeaderFields)
    
    let expectedQuery1 = "\(queryKey)=\(mockQuery)"
    let expectedQuery2 = "\(resourceNameKey)=\(mockResourceName)"
    let expectedQuery = "\(expectedQuery1)&\(expectedQuery2)"
    XCTAssertEqual(mockSession.capturedRequest?.url?.query, expectedQuery)
  }

  func test_finalRequestInclude_subclassHTTPHeaderFields_and_resourceHTTPHeaderFields() {
    let resourceHTTPHeaderFields = ["resource_key": "resource"]
    mockResource = MockHTTPHeaderFieldsNetworkDataResource(url: mockURL, httpHeaderFields: resourceHTTPHeaderFields)
    testService.fetch(resource: mockResource) { _ in }
    let expectedHeaderFields = [commonKey: "subclass", resourceNameKey: mockResourceName, "resource_key": "resource"]
    XCTAssertEqual(mockSession.capturedRequest!.allHTTPHeaderFields!, expectedHeaderFields)
  }

}
