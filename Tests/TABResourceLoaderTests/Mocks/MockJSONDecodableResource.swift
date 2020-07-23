//
//  MockJSONDecodableResource.swift
//  TABResourceLoader
//
//  Created by Sam Dods on 06/10/2017.
//  Copyright © 2017 Kin + Carta. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

// MARK: - Object

struct MockJSONDecodableResource: JSONDecodableResourceType {
  typealias Model = MockObject
  typealias Root = Model
}

struct MockNestedJSONDecodableResource: JSONDecodableResourceType {
  typealias Model = MockObject

  struct ResponseRoot: Decodable {
    let data: NestedData
    struct NestedData: Decodable {
      let mock: MockObject
    }
  }

  func model(mappedFrom root: ResponseRoot) throws -> MockObject {
    return root.data.mock
  }
}

// MARK: - Array

struct MockJSONArrayDecodableResource: JSONDecodableResourceType {
  typealias Model = [MockObject]
  typealias Root = Model
}

struct MockNestedJSONArrayDecodableResource: JSONDecodableResourceType {
  typealias Model = [MockObject]

  struct ResponseRoot: Decodable {
    let data: NestedData
    struct NestedData: Decodable {
      let mocks: [MockObject]
    }
  }

  func model(mappedFrom root: ResponseRoot) throws -> [MockObject] {
    return root.data.mocks
  }
}
