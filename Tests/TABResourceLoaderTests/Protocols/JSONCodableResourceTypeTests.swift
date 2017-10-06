//
//  JSONCodableResourceTypeTests.swift
//  TABResourceLoaderTests
//
//  Created by Sam Dods on 06/10/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

class JSONCodableResourceTypeTests: XCTestCase {

  // MARK: - Valid objects

  func test_validCodableObject() throws {
    let mockResource = MockJSONCodableResource()
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

  func test_validCodableObject_nested() throws {
    let mockResource = MockNestedJSONCodableResource()
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

  func test_validCodableArray() throws {
    let mockResource = MockJSONArrayCodableResource()
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

  func test_validCodableArray_nested() throws {
    let mockResource = MockNestedJSONArrayCodableResource()
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
    let mockResource = MockJSONCodableResource()
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
    let mockResource = MockJSONCodableResource()
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

  func test_modelNotFoundAtTopLevel() throws {
    let mockResource = MockJSONCodableInvalidResource()
    let data = try """
      {
        "data": {
          "mock": {
            "name": "nestedMock"
          }
        }
      }
      """.serialized()

    do {
      _ = try mockResource.model(from: data)
      XCTFail("Expected parsing to fail. Succeeded unexpectedly.")
    } catch let error {
      XCTAssertTrue(error is JSONCodableModelNestingUnspecifiedError)
    }
  }

}
