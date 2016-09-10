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
  var capturedRequest: NSURLRequest?
  var capturedCompletion: ((NSData?, NSURLResponse?, NSError?) -> Void)?

  func performRequest(request: NSURLRequest, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
    capturedRequest = request
    capturedCompletion = completion
  }
}
