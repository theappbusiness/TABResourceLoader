//
//  MockJSONDictionaryResourceType.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

struct MockJSONDictionaryResourceType: JSONDictionaryResourceType {
  typealias Model = MockObject

  func model(from jsonDictionary: [String : Any]) -> MockObject? {
    return MockObject(jsonDictionary: jsonDictionary)
  }

}
