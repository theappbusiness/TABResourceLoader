//
//  NetworkDataResourceServiceTests.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

class MockNetworkServiceActivity: NetworkServiceActivity { }

class NetworkDataResourceServiceTests: XCTestCase {

  var mockSession: MockURLSession!
  var mockResource: MockDefaultNetworkDataResource!
  var mockNetworkServiceActivity: MockNetworkServiceActivity!
  let mockURL = URL(string: "http://test.com")!

  var testService: NetworkDataResourceService<MockDefaultNetworkDataResource>!

  override func setUp() {
    super.setUp()
    mockSession = MockURLSession()
    mockResource = MockDefaultNetworkDataResource(url: mockURL)
    mockNetworkServiceActivity = MockNetworkServiceActivity()
    testService = NetworkDataResourceService<MockDefaultNetworkDataResource>(session: mockSession)
  }

  override func tearDown() {
    mockSession = nil
    mockResource = nil
    mockNetworkServiceActivity = nil
    testService = nil
    super.tearDown()
  }

  func test_publicInitializerUsesNSURLSession() {
    testService = NetworkDataResourceService<MockDefaultNetworkDataResource>()
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
    let newTestRequestManager = NetworkDataResourceService<MockNilURLRequestNetworkJSONResource>(session: mockSession)
    XCTAssertNil(mockInvalidURLResource.urlRequest())
    performAsyncTest { expectation in
      newTestRequestManager.fetch(resource: mockInvalidURLResource) { result in
        expectation?.fulfill()
        guard let error = result.error() else {
          XCTFail("No error found")
          return
        }
        if case NetworkServiceError.couldNotCreateURLRequest = error { return }
        XCTFail("Unexpected error: \(error)")
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
        expectation?.fulfill()
        guard let error = result.error() else {
          XCTFail("No error found")
          return
        }

        guard case NetworkServiceError.statusCodeError(let statusCode) = error else {
          XCTFail()
          return
        }
        XCTAssert(statusCode == expectedStatusCode)
      }
      mockSession.capturedCompletion!(nil, mockHTTPURLResponse, expectedError)
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
        expectation?.fulfill()
        guard let error = result.error() else {
          XCTFail("No error found")
          return
        }

        guard case NetworkServiceError.networkingError(let testError) = error else {
          XCTFail()
          return
        }
        XCTAssert(testError._domain == expectedError._domain)
      }
      mockSession.capturedCompletion!(nil, mockHTTPURLResponse, expectedError)
    }
  }

  func test_fetch_whenSessionCompletesWithNetworkingError_callsFailureWithCorrectError() {
    let expectedError = NSError(domain: "test", code: 999, userInfo: nil) as Error

    performAsyncTest { expectation in
      testService.fetch(resource: mockResource) { result in
        expectation?.fulfill()
        guard let error = result.error() else {
          XCTFail("No error found")
          return
        }

        guard case NetworkServiceError.networkingError(let testError) = error else {
          XCTFail()
          return
        }
        XCTAssert(testError._domain == expectedError._domain)
      }
      mockSession.capturedCompletion!(nil, nil, expectedError)
    }
  }

  func test_fetch_whenSessionCompletes_WithNoData_callsFailureWithCorrectError() {
    performAsyncTest { expectation in
      testService.fetch(resource: mockResource) { result in
        expectation?.fulfill()
        guard let error = result.error() else {
          XCTFail("No error found")
          return
        }
        if case NetworkServiceError.noData = error { return }
        XCTFail()
      }
      mockSession.capturedCompletion!(nil, nil, nil)
    }
  }

  func test_sessionIsInvalidatedOnDeinit() {
    XCTAssertEqual(mockSession.invalidateAndCancelCallCount, 0)
    testService = nil
    XCTAssertEqual(mockSession.invalidateAndCancelCallCount, 1)
  }
}
