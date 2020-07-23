//
//  GlobalFunctionsTests.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 20/02/2017.
//  Copyright © 2017 Kin + Carta. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

class GlobalFunctionsTests: XCTestCase {

  func testMergingTwoDictionaryWithDifferentKeyValuePairs() {
    let left = ["a_key": "a_value"]
    let right = ["b_key": "b_value"]
    guard let mergedDictionary = merge(left, right) else {
      XCTFail(#function)
      return
    }
    let expectedDictionary = ["a_key": "a_value", "b_key": "b_value"]
    XCTAssertEqual(mergedDictionary, expectedDictionary)
  }

  func testMergingTwoNilDictionaryReturnsNil() {
    XCTAssertNil(merge(nil, nil))
  }

  func testMergingLeftNonNilDictionaryWithRightNilDictionary() {
    let dictionary = ["a_key": "a_value"]
    guard let mergedDictionary = merge(dictionary, nil) else {
      XCTFail(#function)
      return
    }
    let expectedDictionary = ["a_key": "a_value"]
    XCTAssertEqual(mergedDictionary, expectedDictionary)
  }

  func testMergingLeftNilDictionaryWithRightNonNilDictionary() {
    let dictionary = ["a_key": "a_value"]
    guard let mergedDictionary = merge(nil, dictionary) else {
      XCTFail(#function)
      return
    }
    let expectedDictionary = ["a_key": "a_value"]
    XCTAssertEqual(mergedDictionary, expectedDictionary)
  }

  func testMergingDictionariesWithCommonKeys() {
    let left = ["a_key": "a_value", "common_key": "a_value"]
    let right = ["b_key": "b_value", "common_key": "b_value"]
    guard let mergedDictionary = merge(left, right) else {
      XCTFail(#function)
      return
    }
    let expectedDictionary = ["a_key": "a_value", "common_key": "b_value", "b_key": "b_value"]
    XCTAssertEqual(mergedDictionary, expectedDictionary)
  }

}
