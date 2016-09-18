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
  var capturedRequest: URLRequest?
  var capturedCompletion: ((Data?, URLResponse?, Error?) -> Void)?

  func performRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    capturedRequest = request
    capturedCompletion = completion
  }
}
