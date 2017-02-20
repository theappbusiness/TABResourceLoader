//
//  JSONArrayResourceTypeTests.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 29/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

class JSONArrayResourceTypeTests: XCTestCase {

  func test_invalidJSONData() {
    let mockJSONArrayResourceType = MockJSONArrayResourceType()
    do {
      let _ = try mockJSONArrayResourceType.model(from: Data())
      XCTFail("No error found")
    } catch {
      XCTAssertEqual(error as? JSONParsingError, JSONParsingError.invalidJSONData)
    }
  }

  func test_invalidJSONDictionary() {
    let mockJSONArrayResourceType = MockJSONArrayResourceType()
    let jsonDictionary = ["invalid_key": "mock"]
    let data = serialize(jsonObject: jsonDictionary)
    do {
      let _ = try mockJSONArrayResourceType.model(from: data)
      XCTFail("No error found")
    } catch {
      XCTAssertEqual(error as? JSONParsingError, JSONParsingError.notAJSONArray)
    }
  }

  func test_cannotParseJSONArray() {
    let mockJSONArrayResourceType = MockJSONArrayResourceType()
    let jsonArray = [["invalid-key"]]
    let data = serialize(jsonObject: jsonArray)
    do {
      let _ = try mockJSONArrayResourceType.model(from: data)
      XCTFail("No error found")
    } catch {
      XCTAssertEqual(error as? JSONParsingError, JSONParsingError.cannotParseJSONArray)
    }
  }

  func test_validJSONArray() {
    let mockJSONArrayResourceType = MockJSONArrayResourceType()
    let jsonArray = [
      ["name": "mock 1"],
      ["name": "mock 2"]
    ]
    let data = serialize(jsonObject: jsonArray)
    guard let result = try? mockJSONArrayResourceType.model(from: data) else {
      XCTFail("No error found")
      return
    }
    let expectedMockObjectsArray = [MockObject(name: "mock 1"), MockObject(name: "mock 2")]
    XCTAssertEqual(result, expectedMockObjectsArray)
  }

}
