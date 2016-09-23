//
//  ResourceOperationTests.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

class ResourceOperationTests: XCTestCase {

  var mockResource: MockResource!
  var mockService: MockResourceService!
  var testResourceOperation: ResourceOperation<MockResourceService>!

  override func setUp() {
    super.setUp()
    mockResource = MockResource()
    mockService = MockResourceService()
    testResourceOperation = ResourceOperation<MockResourceService>(resource: mockResource, service: mockService, didFinishFetchingResourceCallback: { _, _ in })
  }

  func test_didFinishFetchingResource_calledWithCorrectResult() {
    weak var expectation = self.expectation(description: "didFinishFetchingResourceCallback expectation")
    let didFinishFetchingResourceCallback: (ResourceOperation<MockResourceService>, Result<String>) -> Void = { (operation, result) in
      XCTAssertEqual(result.successResult(), "success")
      expectation?.fulfill()
    }
    let resourceOperation = ResourceOperation<MockResourceService>(resource: mockResource, didFinishFetchingResourceCallback: didFinishFetchingResourceCallback)
    resourceOperation.didFinishFetchingResource(result: .success("success"))
    waitForExpectations(timeout: 1, handler: nil)
  }

  func test_createCopy_returnsNewOperation() {
    let testResourceOperation = ResourceOperation<MockResourceService>(resource: mockResource, didFinishFetchingResourceCallback: { _, _ in })
    let copiedResourceOperation = testResourceOperation.createCopy()
    XCTAssertNotEqual(testResourceOperation, copiedResourceOperation)
  }

  func test_createCopy_usesTheSameServiceInstance() {
    let copiedResourceOperation = testResourceOperation.createCopy()
    copiedResourceOperation.execute()
    XCTAssertEqual(mockService.fetchCallCount, 1)
  }

}
