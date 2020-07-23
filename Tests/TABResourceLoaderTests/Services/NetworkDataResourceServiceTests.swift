//
//  NetworkDataResourceServiceTests.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Kin + Carta. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

class MockNetworkServiceActivity: NetworkServiceActivity { }

class NetworkDataResourceServiceTests: XCTestCase {

  var mockSession: MockURLSession!
  var mockResource: MockDefaultNetworkDataResource!
  var mockNetworkServiceActivity: MockNetworkServiceActivity!
  let mockURL = URL(string: "https://test.com")!

  var testService: GenericNetworkDataResourceService<MockDefaultNetworkDataResource>!

  override func setUp() {
    super.setUp()
    mockSession = MockURLSession()
    mockResource = MockDefaultNetworkDataResource(url: mockURL)
    mockNetworkServiceActivity = MockNetworkServiceActivity()
    testService = GenericNetworkDataResourceService<MockDefaultNetworkDataResource>(session: mockSession)
  }

  override func tearDown() {
    mockSession = nil
    mockResource = nil
    mockNetworkServiceActivity = nil
    testService = nil
    MockNetworkServiceActivity.activityChangeHandler = nil
    super.tearDown()
  }

  func test_publicInitializerUsesNSURLSession() {
    testService = GenericNetworkDataResourceService<MockDefaultNetworkDataResource>()
    XCTAssert(testService.session is URLSession)
  }

  func test_fetch_callsPerformRequestOnSessionWithCorrectURLRequest() {
    testService.fetch(resource: mockResource) { _ in }
    let capturedRequest = mockSession.capturedRequest
    let expectedRequest = mockResource.urlRequest()
    XCTAssertNotNil(expectedRequest?.allHTTPHeaderFields)
    XCTAssertEqual(capturedRequest, expectedRequest)
  }

  func test_fetch_incresesAndCompletionDecreaseNumberOfActiveRequests() {
    XCTAssertEqual(mockNetworkServiceActivity.numberOfActiveRequests, 0)
    testService.fetch(resource: mockResource, networkServiceActivity: mockNetworkServiceActivity) { _ in }
    XCTAssertEqual(mockNetworkServiceActivity.numberOfActiveRequests, 1)
    mockSession.capturedCompletion!(nil, nil, nil)
    XCTAssertEqual(mockNetworkServiceActivity.numberOfActiveRequests, 0)
  }

  func test_fetch_incresesAndCompletionDecreaseNumberOfActiveRequests_evenWhenServiceGoesOutOfMemory() {
    let mockNetworkServiceActivity = MockNetworkServiceActivity()
    XCTAssertEqual(mockNetworkServiceActivity.numberOfActiveRequests, 0)
    testService.fetch(resource: mockResource, networkServiceActivity: mockNetworkServiceActivity) { _ in }
    testService = nil
    XCTAssertEqual(mockNetworkServiceActivity.numberOfActiveRequests, 1)
    mockSession.capturedCompletion!(nil, nil, nil)
    XCTAssertEqual(mockNetworkServiceActivity.numberOfActiveRequests, 0)
  }

  func test_fetch_withInvalidURLRequest_callsFailureWithCorrectError() {
    let mockInvalidURLResource = MockNilURLRequestNetworkJSONResource()
    let newTestRequestManager = GenericNetworkDataResourceService<MockNilURLRequestNetworkJSONResource>(session: mockSession)
    XCTAssertNil(mockInvalidURLResource.urlRequest())
    performAsyncTest { expectation in
      newTestRequestManager.fetch(resource: mockInvalidURLResource) { result in
        switch result {
        case .success:
          XCTFail("No error found")
        case .failure(let error, _):
          guard case NetworkServiceError.couldNotCreateURLRequest = error else {
            XCTFail("Unexpected error: \(error)")
            return
          }
        }
        expectation?.fulfill()
      }
    }
  }

  func test_fetch_whenSessionCompletesWithFailureStatusCode_callsFailureWithCorrectError() {
    let handledStatusCodes = [400, 499, 500, 599]
    handledStatusCodes.forEach {
      assert_fetch_whenSessionCompletesWithHandledStatusCode_callsFailureWithCorrectError(expectedStatusCode: $0)
    }
  }

  // MARK: Helpers

  fileprivate func assert_fetch_whenSessionCompletesWithHandledStatusCode_callsFailureWithCorrectError(expectedStatusCode: Int, file: StaticString = #file, lineNumber: UInt = #line) {
    let expectedError = NSError(domain: "test", code: 999, userInfo: nil) as Error
    let mockHTTPURLResponse = HTTPURLResponse(url: URL(string: "www.test.com")!, statusCode: expectedStatusCode, httpVersion: nil, headerFields: nil)
    performAsyncTest(file: file, lineNumber: lineNumber) { expectation in
      testService.fetch(resource: mockResource) { result in
        switch result {
        case .success:
          XCTFail("No error found")
        case .failure(let error, _):
          guard case NetworkServiceError.statusCodeError(let statusCode) = error else {
            XCTFail("Unexpected error: \(error)", file: file, line: lineNumber)
            return
          }
          XCTAssertEqual(statusCode, expectedStatusCode)
          expectation?.fulfill()
        }
      }
      mockSession.capturedCompletion!(nil, mockHTTPURLResponse, expectedError)
    }
  }

  func test_fetch_whenSessionCompletesDataAndHTTPURLResponse_callsSuccessWhenParsingSucceed() {
    performAsyncTest { expectation in
      testService.fetch(resource: mockResource) { result in
        switch result {
        case .success(let model, _):
          XCTAssertEqual(model, "")
          expectation?.fulfill()
        case .failure(let error, _):
          XCTFail("Unexpected error: \(error)")
        }
      }
      let successResponse = HTTPURLResponse(url: mockURL, statusCode: 200, httpVersion: nil, headerFields: nil)
      mockSession.capturedCompletion!(Data(), successResponse, nil)
    }
  }

  func test_fetch_whenSessionCompletesWithUnhandledStatusCode_callsFailureWithCorrectError() {
    let unhandledStatusCodes = [300, 399, 600, 601]
    unhandledStatusCodes.forEach {
      assert_fetch_whenSessionCompletesWithUnhandledStatusCode_callsFailureWithCorrectError(expectedStatusCode: $0)
    }
  }

  fileprivate func assert_fetch_whenSessionCompletesWithUnhandledStatusCode_callsFailureWithCorrectError(expectedStatusCode: Int, file: StaticString = #file, lineNumber: UInt = #line) {
    let expectedError = NSError(domain: "test", code: 999, userInfo: nil) as Error
    let mockHTTPURLResponse = HTTPURLResponse(url: URL(string: "www.test.com")!, statusCode: expectedStatusCode, httpVersion: nil, headerFields: nil)
    performAsyncTest(file: file, lineNumber: lineNumber) { expectation in
      testService.fetch(resource: mockResource) { result in
        switch result {
        case .success:
          XCTFail("No error found")
        case .failure(let error, _):
          guard case NetworkServiceError.sessionError(let testError) = error else {
            XCTFail("Unexpected error: \(error)", file: file, line: lineNumber)
            return
          }
          XCTAssertEqual(testError._domain, expectedError._domain)
          expectation?.fulfill()
        }
      }
      mockSession.capturedCompletion!(nil, mockHTTPURLResponse, expectedError)
    }
  }

  func test_fetch_whenSessionCompletesWithNetworkingError_callsFailureWithCorrectError() {
    let expectedError = NSError(domain: "test", code: 999, userInfo: nil) as Error

    performAsyncTest { expectation in
      testService.fetch(resource: mockResource) { result in
        switch result {
        case .success:
          XCTFail("No error found")
        case .failure(let error, _):
          guard case NetworkServiceError.sessionError(let testError) = error else {
            XCTFail("Unexpected error: \(error)")
            return
          }
          XCTAssertEqual(testError._domain, expectedError._domain)
          expectation?.fulfill()
        }
      }
      mockSession.capturedCompletion!(nil, nil, expectedError)
    }
  }

  func test_fetch_whenSessionCompletes_WithNoData_callsFailureWithCorrectError() {
    performAsyncTest { expectation in
      testService.fetch(resource: mockResource) { result in
        switch result {
        case .success:
          XCTFail("No error found")
        case .failure(let error, _):
          guard case NetworkServiceError.noDataProvided = error else {
            XCTFail("Unexpected error: \(error)")
            return
          }
          expectation?.fulfill()
        }
      }
      mockSession.capturedCompletion!(nil, HTTPURLResponse(), nil)
    }
  }

  func test_sessionIsInvalidatedOnDeinit() {
    XCTAssertEqual(mockSession.invalidateAndCancelCallCount, 0)
    testService = nil
    XCTAssertEqual(mockSession.invalidateAndCancelCallCount, 1)
  }

  func test_fetch_returnsANonNilCancellable() {
    let cancellable = testService.fetch(resource: mockResource) { _ in }
    XCTAssertNotNil(cancellable)
  }

  func test_activityChangeHandlerIsCalledOnMainThread() {
    let mockNetworkServiceActivity = MockNetworkServiceActivity()
    let expectation = self.expectation(description: #function)
    MockNetworkServiceActivity.activityChangeHandler = { _ in
      XCTAssertEqual(Thread.current, Thread.main)
      expectation.fulfill()
    }
    DispatchQueue.global().async {
      self.testService.fetch(resource: self.mockResource, networkServiceActivity: mockNetworkServiceActivity) { _ in }
    }
    waitForExpectation()
  }

  func testCancelAllRequests() {
    testService = GenericNetworkDataResourceService<MockDefaultNetworkDataResource>()
    performAsyncTest { expectation in
      testService.fetch(resource: mockResource) { result in
        switch result {
        case .failure(.sessionError(let error), _):
          if error._code == NSURLErrorCancelled && error._domain == NSURLErrorDomain {
            expectation?.fulfill()
          }
        default:
          XCTFail("No error found")
        }
      }
      testService.cancelAllRequests()
    }
  }
}
