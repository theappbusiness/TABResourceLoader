//
//  NetworkDataResourceServiceURLSessionTests.swift
//  TABResourceLoader
//
//  Created by Sam Dods on 12/01/2017.
//  Copyright © 2017 Kin + Carta. All rights reserved.
//

import XCTest
import TABResourceLoader // note this is intentionally *not* @testable, so we can confirm URLSession is exposed

class MockSessionToTestExposed: URLSessionType {
  public func perform(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    completion(Data(), nil, nil)
    return URLSessionDataTask()
  }
  func invalidateAndCancel() { /* not implemented */ }
  func cancelAllRequests() { /* not implemented */ }
}

class NetworkDataResourceServiceURLSessionTests: XCTestCase { //swiftlint:disable:this type_name

  struct MockResource: NetworkResourceType, DataResourceType {
    typealias Model = String
    var url = URL(string: "test")!
    func model(from data: Data) throws -> Model {
      return "done"
    }
  }

  func test_initWithURLSession() {
    let service = GenericNetworkDataResourceService<MockResource>(session: MockSessionToTestExposed())
    let resource = MockResource()

    var hasFetched = false
    performAsyncTest { expectation in
      service.fetch(resource: resource) { _ in
        hasFetched = true
        expectation?.fulfill()
      }
    }
    XCTAssertTrue(hasFetched)
  }

}
