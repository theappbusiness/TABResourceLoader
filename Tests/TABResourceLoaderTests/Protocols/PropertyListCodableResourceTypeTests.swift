//
//  PropertyListCodableResourceTypeTests.swift
//  TABResourceLoaderTests
//
//  Created by Sam Dods on 06/10/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

class PropertyListCodableResourceTypeTests: XCTestCase {

  // MARK: - Valid objects

  func test_validCodableObject() throws {
    let mockResource = MockPropertyListCodableResource()
    let data = try """
      <plist version="1.0"><dict>
        <key>name</key><string>mock</string>
      </dict></plist>
      """.serialized()

    guard let result = try? mockResource.model(from: data) else {
      XCTFail("Unable to decode")
      return
    }
    let expectedResult = MockObject(name: "mock")
    XCTAssertEqual(result, expectedResult)
  }

  func test_validCodableObject_nested() throws {
    let mockResource = MockNestedPropertyListCodableResource()
    let data = try """
      <plist version="1.0"><dict>
        <key>data</key><dict>
          <key>mock</key><dict>
            <key>name</key><string>nestedMock</string>
          </dict>
        </dict>
      </dict></plist>
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
    let mockResource = MockPropertyListArrayCodableResource()
    let data = try """
      <plist version="1.0"><array>
        <dict>
          <key>name</key><string>1</string>
        </dict>
        <dict>
          <key>name</key><string>2</string>
        </dict>
      </array></plist>
      """.serialized()

    guard let result = try? mockResource.model(from: data) else {
      XCTFail("Unable to decode")
      return
    }
    let expectedResult = [MockObject(name: "1"), MockObject(name: "2")]
    XCTAssertEqual(result, expectedResult)
  }

  func test_validCodableArray_nested() throws {
    let mockResource = MockNestedPropertyListArrayCodableResource()
    let data = try """
      <plist version="1.0"><dict>
        <key>data</key><dict>
          <key>mocks</key><array>
            <dict>
              <key>name</key><string>1</string>
            </dict>
            <dict>
              <key>name</key><string>2</string>
            </dict>
          </array>
        </dict>
      </dict></plist>
      """.serialized()

    guard let result = try? mockResource.model(from: data) else {
      XCTFail("Unable to decode")
      return
    }
    let expectedResult = [MockObject(name: "1"), MockObject(name: "2")]
    XCTAssertEqual(result, expectedResult)
  }

  // MARK: Errors

  func test_invalidPropertyList() throws {
    let mockResource = MockPropertyListCodableResource()
    let data = try """
      <plist version="1.0"><dict>
        <key>data</key><dict>
          <key>mocks</key><array>
            <dict>
              <key>name</key><string>1</string>
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

  func test_PropertyListFailsDecoding() throws {
    let mockResource = MockPropertyListCodableResource()
    let data = try """
      <plist version="1.0"><dict>
        <key>id</key><string>mock</string>
      </dict></plist>
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
