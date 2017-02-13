//
//  JSONDictionaryResourceTypeTests.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 29/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

class JSONDictionaryResourceTypeTests: XCTestCase {

  func test_invalidJSONData() {
    let mockJSONObjectResourceType = MockJSONDictionaryResourceType()
    let result = mockJSONObjectResourceType.result(from: Data())
    guard let error = result.error() else {
      XCTFail("No error found")
      return
    }
    if case JSONParsingError.invalidJSONData = error { return }
    XCTFail()
  }

  func test_notAJSONDictionary() {
    let mockJSONObjectResourceType = MockJSONDictionaryResourceType()
    let jsonArray = ["invalid_key"]
    let data = serialize(jsonObject: jsonArray)
    let result = mockJSONObjectResourceType.result(from: data)
    guard let error = result.error() else {
      XCTFail(#function)
      return
    }
    if case JSONParsingError.notAJSONDictionary = error { return }
    XCTFail("Did not match correct error: \(error)")
  }

  func test_cannotParseJSONDictionary() {
    let mockJSONObjectResourceType = MockJSONDictionaryResourceType()
    let jsonDictionary = ["invalid_key": "mock"]
    let data = serialize(jsonObject: jsonDictionary)
    let result = mockJSONObjectResourceType.result(from: data)
    guard let error = result.error() else {
      XCTFail("No error found")
      return
    }
    if case JSONParsingError.cannotParseJSONDictionary = error { return }
    XCTFail("Did not match correct error: \(error)")
  }

  func test_validJSONDictionary() {
    let mockJSONObjectResourceType = MockJSONDictionaryResourceType()
    let jsonDictionary = ["name": "mock"]
    let data = serialize(jsonObject: jsonDictionary)
    let result = mockJSONObjectResourceType.result(from: data)
    guard let calculatedMockObject = result.successResult() else {
      XCTFail("No error found")
      return
    }
    let expectedMockObject = MockObject(name: "mock")
    XCTAssertEqual(calculatedMockObject, expectedMockObject)
  }

}
