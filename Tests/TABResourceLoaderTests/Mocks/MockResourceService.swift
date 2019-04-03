//
//  MockResourceService.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

class MockSessionThatDoesNothing: URLSessionType {

  public func perform(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    return URLSessionDataTask()
  }
  func invalidateAndCancel() { /* not implemented */ }
  func cancelAllRequests() { /* not implemented */ }
}

class MockResourceService: ResourceServiceType {

  required init() {}

  typealias Resource = MockResource

  var capturedResource: Resource?
  var capturedCompletion: ((Result<Resource.Model, Error>) -> Void)?
  var fetchCallCount: Int = 0
  var mockReturnedCancellable: Cancellable?

  required init(session: URLSessionType = MockSessionThatDoesNothing()) {}

  func fetch(resource: Resource, completion: @escaping (Result<Resource.Model, Error>) -> Void) -> Cancellable? {
    capturedResource = resource
    capturedCompletion = completion
    fetchCallCount += 1
    return mockReturnedCancellable
  }

}
