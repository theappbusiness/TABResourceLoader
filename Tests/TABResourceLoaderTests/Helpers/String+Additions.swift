//
//  String+Additions.swift
//  TABResourceLoader
//
//  Created by Sam Dods on 06/10/2017.
//  Copyright © 2017 Kin + Carta. All rights reserved.
//

import XCTest

struct StringSerializationError: Error {}

extension String {

  /// Returns the string converted to data using UTF8 encoding.
  ///
  /// - Returns: The UTF8-encoded data of the receiver.
  /// - Throws: A `StringSerializationError` if the string could not be converted to data.
  func serialized(file: StaticString = #file, line: UInt = #line) throws -> Data {
    guard let data = self.data(using: .utf8) else {
      XCTFail("Failed to serialize data", file: file, line: line)
      throw StringSerializationError()
    }
    return data
  }
}
