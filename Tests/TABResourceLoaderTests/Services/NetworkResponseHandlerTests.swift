//
//  NetworkResponseHandlerTests.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 16/05/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

struct MockParsingFailedResource: NetworkResourceType, DataResourceType {
  typealias Model = String
  let url: URL = URL(string: "http://test.com")!

  func model(from data: Data) throws -> String {
    throw "Parsing failed"
  }

}

struct MockErrorResponseResource: NetworkResourceType, DataResourceType {
  typealias Model = String
  let url: URL = URL(string: "http://test.com")!

  func model(from data: Data) throws -> String {
    return "Success"
  }

  func error(from data: Data) -> Error? {
    return "Parsing error failed"
  }

}

class NetworkResponseHandlerTests: XCTestCase {

  let mockURL = URL(string: "http://test.com")!

  func test_resultIsStatusCodeFailureWhenModelParsingFailsForSuccessfullStatusCodes() {
    let successResponse = HTTPURLResponse(url: mockURL, statusCode: 204, httpVersion: nil, headerFields: nil)
    let response = NetworkResponseHandler.resultFrom(resource: MockParsingFailedResource(), data: Data(), URLResponse: successResponse, error: nil)
    guard case NetworkResponse.failure(let error, let urlResponse) = response,
          case NetworkServiceError.statusCodeError(let statusCode) = error else {
        XCTFail()
        return
    }
    XCTAssertEqual(statusCode, 204)
    XCTAssertEqual(successResponse, urlResponse)
  }

  func test_resultIsCouldNotParseModelWhenErrorParsingSucceedsForErrorStatusCodes() {
    let successResponse = HTTPURLResponse(url: mockURL, statusCode: 504, httpVersion: nil, headerFields: nil)
    let response = NetworkResponseHandler.resultFrom(resource: MockErrorResponseResource(), data: Data(), URLResponse: successResponse, error: nil)
    guard case NetworkResponse.failure(let error, let urlResponse) = response,
          case NetworkServiceError.couldNotParseModel(let errorModel) = error else {
        XCTFail("Unexpected response: \(response)")
        return
    }
    XCTAssertEqual(errorModel as? String, "Parsing error failed")
    XCTAssertEqual(successResponse, urlResponse)
  }

  func test_resultIsStatusCodeFailureWhenErrorParsingFailsForErrorStatusCodes() {
    let successResponse = HTTPURLResponse(url: mockURL, statusCode: 504, httpVersion: nil, headerFields: nil)
    let response = NetworkResponseHandler.resultFrom(resource: MockParsingFailedResource(), data: Data(), URLResponse: successResponse, error: nil)
    guard case NetworkResponse.failure(let error, let urlResponse) = response,
          case NetworkServiceError.statusCodeError(let statusCode) = error else {
        XCTFail("Unexpected response: \(response)")
        return
    }
    XCTAssertEqual(statusCode, 504)
    XCTAssertEqual(successResponse, urlResponse)
  }
}
