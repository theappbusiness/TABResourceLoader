//
//  NetworkDataResourceServiceURLSessionTests.swift
//  TABResourceLoader
//
//  Created by Sam Dods on 12/01/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import XCTest
import TABResourceLoader // note this is intentionally *not* @testable, so we can confirm URLSession is exposed

class MockSessionToTestExposed: URLSessionType {
  func perform(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    completion(Data(), nil, nil)
  }
}

class NetworkDataResourceServiceURLSessionTests: XCTestCase { //swiftlint:disable:this type_name

  struct MockResource: NetworkResourceType, DataResourceType {
    typealias Model = String
    var url = URL(string: "test")!
    func result(from data: Data) -> Result<Model> {
      return .success("done")
    }
  }

  func test_initWithURLSession() {
    let service = NetworkDataResourceService<MockResource>(session: MockSessionToTestExposed())
    let resource = MockResource()

    var hasFetched = false
    performAsyncTest { expectation in
      service.fetch(resource: resource) { result in
        hasFetched = true
        expectation?.fulfill()
      }
    }
    XCTAssertTrue(hasFetched)
  }

}
