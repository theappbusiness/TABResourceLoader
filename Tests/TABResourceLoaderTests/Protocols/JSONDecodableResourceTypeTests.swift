//
//  JSONDecodableResourceTypeTests.swift
//  TABResourceLoaderTests
//
//  Created by Sam Dods on 06/10/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

class JSONDecodableResourceTypeTests: XCTestCase {

  // MARK: - Valid objects

  func test_validDecodableObject() throws {
    let mockResource = MockJSONDecodableResource()
    let data = try """
      {
        "name": "mock"
      }
      """.serialized()

    guard let result = try? mockResource.model(from: data) else {
      XCTFail("Unable to decode")
      return
    }
    let expectedResult = MockObject(name: "mock")
    XCTAssertEqual(result, expectedResult)
  }

  func test_validDecodableObject_nested() throws {
    let mockResource = MockNestedJSONDecodableResource()
    let data = try """
      {
        "data": {
          "mock": {
            "name": "nestedMock"
          }
        }
      }
      """.serialized()

    guard let result = try? mockResource.model(from: data) else {
      XCTFail("Unable to decode")
      return
    }
    let expectedResult = MockObject(name: "nestedMock")
    XCTAssertEqual(result, expectedResult)
  }

  // MARK: Valid arrays

  func test_validDecodableArray() throws {
    let mockResource = MockJSONArrayDecodableResource()
    let data = try """
      [
        {
          "name": "1"
        },
        {
          "name": "2"
        }
      ]
      """.serialized()

    guard let result = try? mockResource.model(from: data) else {
      XCTFail("Unable to decode")
      return
    }
    let expectedResult = [MockObject(name: "1"), MockObject(name: "2")]
    XCTAssertEqual(result, expectedResult)
  }

  func test_validDecodableArray_nested() throws {
    let mockResource = MockNestedJSONArrayDecodableResource()
    let data = try """
      {
        "data": {
          "mocks": [
            {
              "name": "1"
            },
            {
              "name": "2"
            }
          ]
        }
      }
      """.serialized()

    guard let result = try? mockResource.model(from: data) else {
      XCTFail("Unable to decode")
      return
    }
    let expectedResult = [MockObject(name: "1"), MockObject(name: "2")]
    XCTAssertEqual(result, expectedResult)
  }

  // MARK: Errors

  func test_invalidJSON() throws {
    let mockResource = MockJSONDecodableResource()
    let data = try """
      {
        "id": "mo
      """.serialized()

    do {
      _ = try mockResource.model(from: data)
      XCTFail("Expected parsing to fail. Succeeded unexpectedly.")
    } catch let error {
      guard case DecodingError.dataCorrupted = error else {
        XCTFail("Expected DecodingError.dataCorrupted. Got: \(error.localizedDescription)")
        return
      }
    }
  }

  func test_jsonFailsDecoding() throws {
    let mockResource = MockJSONDecodableResource()
    let data = try """
      {
        "id": "mock"
      }
      """.serialized()

    do {
      _ = try mockResource.model(from: data)
      XCTFail("Expected parsing to fail. Succeeded unexpectedly.")
    } catch let error {
      guard case DecodingError.keyNotFound = error else {
        XCTFail("Expected DecodingError.keyNotFound. Got: \(error.localizedDescription)")
        return
      }
    }
  }
}
