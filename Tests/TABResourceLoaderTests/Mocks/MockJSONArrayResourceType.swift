//
//  MockJSONArrayResourceType.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Kin + Carta. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

struct MockJSONArrayResourceType: JSONArrayResourceType {
  typealias Model = [MockObject]

  func model(from jsonArray: [Any]) throws -> [MockObject] {
    let parsedMockObjects: [MockObject] = jsonArray.compactMap {
      guard let jsonDictionary = $0 as? [String: Any] else { return nil }
      return MockObject(jsonDictionary: jsonDictionary)
    }
    guard parsedMockObjects.count > 0 else { throw JSONParsingError.cannotParseJSONArray }
    return parsedMockObjects
  }

}
