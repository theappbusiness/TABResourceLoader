//
//  NetworkDataTransformableResourceServiceTests.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

class NetworkDataTransformableResourceServiceTests: XCTestCase {
  
  var mockSession: MockURLSession!
  var mockResource: MockDefaultNetworkJSONResource!
  let mockURL = NSURL(string: "http://test.com")!
  
  var testService: NetworkDataTransformableResourceService<MockDefaultNetworkJSONResource>!
  
  override func setUp() {
    super.setUp()
    mockSession = MockURLSession()
    mockResource = MockDefaultNetworkJSONResource(url: mockURL)
    
    testService = NetworkDataTransformableResourceService<MockDefaultNetworkJSONResource>(session: mockSession)
  }
  
  func test_publicInitializerUsesNSURLSession() {
    testService = NetworkDataTransformableResourceService<MockDefaultNetworkJSONResource>()
    XCTAssert(testService.session is NSURLSession)
  }
  
  func test_fetch_callsPerformRequestOnSessionWithCorrectURLRequest() {
    testService.fetch(resource: mockResource) { _ in }
    let capturedRequest = mockSession.capturedRequest
    let expectedRequest = mockResource.urlRequest()
    XCTAssertNotNil(expectedRequest?.allHTTPHeaderFields)
    XCTAssertEqual(capturedRequest, expectedRequest)
  }

  func test_fetch_withInvalidURLRequest_callsFailureWithCorrectError() {
    let mockInvalidURLResource = MockNilURLRequestNetworkJSONResource()
    let newTestRequestManager = NetworkDataTransformableResourceService<MockNilURLRequestNetworkJSONResource>(session: mockSession)
    XCTAssertNil(mockInvalidURLResource.urlRequest())
    performAsyncTest() { expectation in
      newTestRequestManager.fetch(resource: mockInvalidURLResource) { result in
        expectation?.fulfill()
        guard let error = result.error() else {
          XCTFail("No error found")
          return
        }
        if case NetworkServiceError.CouldNotCreateURLRequest = error { return }
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
  
  //MARK: Helpers

  private func assert_fetch_whenSessionCompletesWithHandledStatusCode_callsFailureWithCorrectError(expectedStatusCode expectedStatusCode: Int, file: StaticString = #file, lineNumber: UInt = #line) {
    let expectedError = NSError(domain: "test", code: 999, userInfo: nil)
    let mockHTTPURLResponse = NSHTTPURLResponse(URL: NSURL(string: "www.test.com")!, statusCode: expectedStatusCode, HTTPVersion: nil, headerFields: nil)
    performAsyncTest(file: file, lineNumber: lineNumber) { expectation in
      testService.fetch(resource: mockResource) { result in
        expectation?.fulfill()
        guard let error = result.error() else {
          XCTFail("No error found")
          return
        }

        guard case NetworkServiceError.StatusCodeError(let statusCode) = error else {
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

  private func assert_fetch_whenSessionCompletesWithUnhandledStatusCode_callsFailureWithCorrectError(expectedStatusCode expectedStatusCode: Int, file: StaticString = #file, lineNumber: UInt = #line) {
    let expectedError = NSError(domain: "test", code: 999, userInfo: nil)
    let mockHTTPURLResponse = NSHTTPURLResponse(URL: NSURL(string: "www.test.com")!, statusCode: expectedStatusCode, HTTPVersion: nil, headerFields: nil)
    performAsyncTest(file: file, lineNumber: lineNumber) { expectation in
      testService.fetch(resource: mockResource) { result in
        expectation?.fulfill()
        guard let error = result.error() else {
          XCTFail("No error found")
          return
        }

        guard case NetworkServiceError.NetworkingError(let testError) = error else {
          XCTFail()
          return
        }
        XCTAssert(testError.domain == expectedError.domain)
      }
      mockSession.capturedCompletion!(nil, mockHTTPURLResponse, expectedError)
    }
  }

  func test_fetch_whenSessionCompletesWithNetworkingError_callsFailureWithCorrectError() {
    let expectedError = NSError(domain: "test", code: 999, userInfo: nil)

    performAsyncTest() { expectation in
      testService.fetch(resource: mockResource) { result in
        expectation?.fulfill()
        guard let error = result.error() else {
          XCTFail("No error found")
          return
        }

        guard case NetworkServiceError.NetworkingError(let testError) = error else {
          XCTFail()
          return
        }
        XCTAssert(testError.domain == expectedError.domain)
      }
      mockSession.capturedCompletion!(nil, nil, expectedError)
    }
  }

  func test_fetch_whenSessionCompletes_WithNoData_callsFailureWithCorrectError() {
    performAsyncTest() { expectation in
      testService.fetch(resource: mockResource)  { result in
        expectation?.fulfill()
        guard let error = result.error() else {
          XCTFail("No error found")
          return
        }
        if case NetworkServiceError.NoData = error { return }
        XCTFail()
      }
      mockSession.capturedCompletion!(nil, nil, nil)
    }
  }

  func test_fetch_WhenSessionCompletes_WithInvalidJSON_callsFailureWithCorrectError() {
    performAsyncTest() { expectation in
      testService.fetch(resource: mockResource) { result in
        expectation?.fulfill()
        guard let error = result.error() else {
          XCTFail("No error found")
          return
        }
        if case JSONParsingError.InvalidJSONData = error { return }
        XCTFail()
      }
      mockSession.capturedCompletion!(NSData(), nil, nil)
    }
  }

}
