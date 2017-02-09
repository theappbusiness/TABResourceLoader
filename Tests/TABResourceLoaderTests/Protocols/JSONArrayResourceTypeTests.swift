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
    let mockJSONObjectResourceType = MockJSONArrayResourceType()
    let result = mockJSONObjectResourceType.result(from: Data())
    guard let error = result.error() else {
      XCTFail("No error found")
      return
    }
    if case JSONParsingError.invalidJSONData = error { return }
    XCTFail()
  }

  func test_invalidJSONDictionary() {
    let mockJSONObjectResourceType = MockJSONArrayResourceType()
    let jsonDictionary = ["invalid_key": "mock"]
    let data = serialize(jsonObject: jsonDictionary)
    let result = mockJSONObjectResourceType.result(from: data)
    guard let error = result.error() else {
      XCTFail("No error found")
      return
    }
    if case JSONParsingError.notAJSONArray = error { return }
    XCTFail("Did not match correct error: \(error)")
  }

  func test_cannotParseJSONArray() {
    let mockJSONObjectResourceType = MockJSONArrayResourceType()
    let jsonArray = [["invalid-key"]]
    let data = serialize(jsonObject: jsonArray)
    let result = mockJSONObjectResourceType.result(from: data)
    guard let error = result.error() else {
      XCTFail("No error found")
      return
    }
    if case JSONParsingError.cannotParseJSONArray = error { return }
    XCTFail()
  }

  func test_validJSONArray() {
    let mockJSONObjectResourceType = MockJSONArrayResourceType()
    let jsonArray = [
      ["name": "mock 1"],
      ["name": "mock 2"]
    ]
    let data = serialize(jsonObject: jsonArray)
    let result = mockJSONObjectResourceType.result(from: data)
    guard let calculatedMockObjectsArray = result.successResult() else {
      XCTFail("No error found")
      return
    }
    let expectedMockObjectsArray = [MockObject(name: "mock 1"), MockObject(name: "mock 2")]
    XCTAssertEqual(calculatedMockObjectsArray, expectedMockObjectsArray)
  }

}
