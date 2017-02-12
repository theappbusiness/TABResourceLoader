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
  var sut: ResourceOperation<MockResourceService>!

  override func setUp() {
    super.setUp()
    mockResource = MockResource()
    mockService = MockResourceService()
    sut = ResourceOperation<MockResourceService>(resource: mockResource, service: mockService, didFinishFetchingResourceCallback: { _, _ in })
  }

  override func tearDown() {
    mockResource = nil
    mockService = nil
    sut = nil
    super.tearDown()
  }

  func test_createCopy_returnsNewOperation() {
    let copiedResourceOperation = sut.createCopy()
    XCTAssertNotEqual(sut, copiedResourceOperation)
  }

  func test_createCopy_usesTheSameServiceInstance() {
    let copiedResourceOperation = sut.createCopy()
    XCTAssert(copiedResourceOperation.service === mockService)
  }

  func test_executeCallsFetchOnService() {
    sut.execute()
    XCTAssertEqual(mockService.fetchCallCount, 1)
  }

  func test_execute_callsDidFinishFetchingResourceCallback_withCorrectResultOnSuccess() {
    let finishExpectation = expectation(description: #function)
    sut = ResourceOperation<MockResourceService>(resource: mockResource, service: mockService) { _, result in
      XCTAssertEqual(result.successResult(), "some result")
      finishExpectation.fulfill()
    }
    sut.execute()
    mockService.capturedCompletion!(.success("some result"))
    waitForExpectation()
  }

  func test_execute_callsDidFinishFetchingResourceCallback_onMainThread() {
    let finishExpectation = expectation(description: #function)
    sut = ResourceOperation<MockResourceService>(resource: mockResource, service: mockService) { _, _ in
      XCTAssert(Thread.isMainThread)
      finishExpectation.fulfill()
    }
    DispatchQueue.global().async {
      self.sut.execute()
      self.mockService.capturedCompletion!(.success(""))
    }
    waitForExpectation()
  }

  func test_executeCallsFinishOnCompletion() {
    sut.execute()
    mockService.capturedCompletion!(.success("some result"))
    XCTAssert(sut.isFinished)
  }

  func test_execute_doesNotCallFetchOnService_whenOperationIsCancelled_beforeServiceFetches() {
    sut.cancel()
    sut.execute()
    XCTAssertNil(mockService.capturedCompletion)
  }

  func test_execute_doesNotCallFinishAndDidFinish_whenOperationIsCancelled_afterServiceFetches() {
    sut = ResourceOperation<MockResourceService>(resource: mockResource, service: mockService) { _, _ in
      XCTFail("Operation was cancelled, so this should not have been executed")
    }
    sut.execute()
    sut.cancel()
    let expectedResult = Result.success("some result")
    mockService.capturedCompletion!(expectedResult)
    XCTAssertFalse(sut.isFinished)
  }

}
