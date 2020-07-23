//
//  MockURLSession.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Kin + Carta. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

final class MockURLSession: URLSessionType {

  typealias URLSessionCompletionHandler = (Data?, URLResponse?, Error?) -> Void

  var capturedRequest: URLRequest?
  var capturedCompletion: URLSessionCompletionHandler?
  var invalidateAndCancelCallCount = 0

  func perform(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    capturedRequest = request
    capturedCompletion = completion
    return URLSessionDataTask()
  }

  func invalidateAndCancel() {
    invalidateAndCancelCallCount += 1
  }

 func cancelAllRequests() { /* not implemented */ }
}
