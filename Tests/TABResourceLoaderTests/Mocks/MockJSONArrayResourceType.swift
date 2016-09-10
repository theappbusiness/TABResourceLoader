//
//  MockJSONArrayResourceType.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

struct MockJSONArrayResourceType: JSONResourceType {
  typealias Model = [MockObject]

  func modelFrom(jsonArray: [AnyObject]) -> [MockObject]? {
    let parsedMockObjects: [MockObject] = jsonArray.flatMap {
      guard let jsonDictionary = $0 as? [String: AnyObject] else { return nil }
      return MockObject(jsonDictionary: jsonDictionary)
    }
    guard parsedMockObjects.count > 0 else { return nil }
    return parsedMockObjects
  }
  
}
