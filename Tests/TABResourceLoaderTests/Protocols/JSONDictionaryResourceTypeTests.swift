//
//  JSONDictionaryResourceTypeTests.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 29/09/2016.
//  Copyright © 2016 Kin + Carta. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

class JSONDictionaryResourceTypeTests: XCTestCase {

  func test_invalidJSONData() {
    let mockJSONObjectResourceType = MockJSONDictionaryResourceType()
    do {
      _ = try mockJSONObjectResourceType.model(from: Data())
      XCTFail("No error found")
    } catch {
      XCTAssertEqual(error as? JSONParsingError, JSONParsingError.invalidJSONData)
    }
  }

  func test_notAJSONDictionary() {
    let mockJSONObjectResourceType = MockJSONDictionaryResourceType()
    let jsonArray = ["invalid_key"]
    let data = serialize(jsonObject: jsonArray)
    do {
      _ = try mockJSONObjectResourceType.model(from: data)
      XCTFail("No error found")
    } catch {
      XCTAssertEqual(error as? JSONParsingError, JSONParsingError.notAJSONDictionary)
    }
  }

  func test_cannotParseJSONDictionary() {
    let mockJSONObjectResourceType = MockJSONDictionaryResourceType()
    let jsonDictionary = ["invalid_key": "mock"]
    let data = serialize(jsonObject: jsonDictionary)
    do {
      _ = try mockJSONObjectResourceType.model(from: data)
      XCTFail("No error found")
    } catch {
      XCTAssertEqual(error as? JSONParsingError, JSONParsingError.cannotParseJSONDictionary)
    }
  }

  func test_validJSONDictionary() {
    let mockJSONObjectResourceType = MockJSONDictionaryResourceType()
    let jsonDictionary = ["name": "mock"]
    let data = serialize(jsonObject: jsonDictionary)
    guard let calculatedMockObject = try? mockJSONObjectResourceType.model(from: data) else {
      XCTFail("No error found")
      return
    }
    let expectedMockObject = MockObject(name: "mock")
    XCTAssertEqual(calculatedMockObject, expectedMockObject)
  }

  func test_defaultErrorIsNil() {
    let mockJSONObjectResourceType = MockJSONDictionaryResourceType()
    XCTAssertNil(mockJSONObjectResourceType.error(from: [:]))
  }

}
