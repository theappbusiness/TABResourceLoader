//
//  MockResourceService.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

class MockResourceService: ResourceServiceType {

  typealias Resource = MockResource

  var capturedResource: Resource?
  var capturedCompletion: ((Result<Resource.Model>) -> Void)?

  required init() {}

  func fetch(resource: Resource, completion: @escaping (Result<Resource.Model>) -> Void) {
    capturedResource = resource
    capturedCompletion = completion
  }

}
