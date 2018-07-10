//
//  Dictionary+AdditionsTests.swift
//  TABResourceLoader
//
//  Created by John Sanderson on 30/01/2018.
//  Copyright © 2018 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

class DictionaryAdditionsTests: XCTestCase {

  func testDictionary_returnedAsFormDataString() {
    let dictionary: [String: CustomStringConvertible] = ["firstKey": "withAValue",
                                                         "secondKey": true,
                                                         "lastKey": 4]
    let formDataString = dictionary.formDataPostString
    XCTAssertEqual(formDataString, "firstKey=withAValue&secondKey=true&lastKey=4")
  }

}
