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

  override func setUp() {
    super.setUp()
    mockResource = MockResource()
  }

  func test_didFinishFetchingResource_calledWithCorrectResult() {
    weak var expectation = expectationWithDescription("didFinishFetchingResourceCallback expectation")
    let didFinishFetchingResourceCallback: (ResourceOperation<MockResourceService>, Result<String>) -> Void = { (operation, result) in
      XCTAssertEqual(result.successResult(), "success")
      expectation?.fulfill()
    }
    let resourceOperation = ResourceOperation<MockResourceService>(resource: mockResource, didFinishFetchingResourceCallback: didFinishFetchingResourceCallback)
    resourceOperation.didFinishFetchingResource(result: .Success("success"))
    waitForExpectationsWithTimeout(1, handler: nil)
  }

}