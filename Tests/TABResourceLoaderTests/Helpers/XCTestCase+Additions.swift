//
//  XCTestCase+Additions.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Kin + Carta. All rights reserved.
//

import XCTest

extension XCTestCase {

  /**
   Helper for running async unit tests, creates an expectation and waits for that expectation with
   a defined timeout.

   - parameter timeout:        Time to wait for the expectation to fufill default value of one second
   - parameter failureMessage: Failure message to be shown when the test fails
   - parameter runTest:        A block used to wrap the test to be run asynchronously. The block has an
   input paramater of the expectation this function will wait for. Your test
   must fufill this expectation or the test will fail.
   */
  func performAsyncTest(_ timeout: TimeInterval = 1.0, failureMessage: String? = nil, file: StaticString = #file, lineNumber: UInt = #line, test runTest: (XCTestExpectation?) -> Void) {
    weak var expectation = self.expectation(description: "Async test expectation")
    runTest(expectation)
    waitForExpectations(timeout: timeout) { error in
      guard let error = error else {
        return
      }
      let failureMessage = failureMessage ?? error.localizedDescription
      XCTFail(failureMessage, file: file, line: lineNumber)
    }
  }

  /// Convenience function for waiting for an expectation, timeout defaults to 1
  func waitForExpectation(file: StaticString = #file, line: UInt = #line) {
    waitForExpectations(timeout: 1) { error in
      if let error = error { XCTFail("\(error)", file: file, line: line) }
    }
  }

  /// Convenience function to serialize a JSON object, if serialization fails an XCTest assertion is raised
  ///
  /// - Parameter jsonObject: The object to serialize
  /// - Returns: Returns the serialized data or Data() if serialization fails
  func serialize(jsonObject: Any, file: StaticString = #file, line: UInt = #line) -> Data {
    guard let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions.prettyPrinted) else {
      XCTFail("Failed to serialize data", file: file, line: line)
      return Data()
    }
    return data
  }

}
