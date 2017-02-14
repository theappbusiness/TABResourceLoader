//
//  MockURLSession.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

final class MockURLSession: URLSessionType {

  typealias URLSessionCompletionHandler = (Data?, URLResponse?, Error?) -> Void

  var capturedRequest: URLRequest?
  var capturedCompletion: URLSessionCompletionHandler?
  var invalidateAndCancelCallCount = 0

  func perform(request: URLRequest, completion: @escaping URLSessionCompletionHandler) {
    capturedRequest = request
    capturedCompletion = completion
  }

  func invalidateAndCancel() {
    invalidateAndCancelCallCount += 1
  }
}
