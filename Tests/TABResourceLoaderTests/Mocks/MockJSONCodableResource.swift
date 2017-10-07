//
//  MockJSONCodableResource.swift
//  TABResourceLoader
//
//  Created by Sam Dods on 06/10/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

// swiftlint:disable nesting

// MARK: - Object

struct MockJSONCodableResource: JSONDecodableResourceType {
  typealias Model = MockObject
  typealias Root = Model
}

struct MockNestedJSONCodableResource: JSONDecodableResourceType {
  typealias Model = MockObject

  struct ResponseRoot: Codable {
    let data: NestedData
    struct NestedData: Codable {
      let mock: MockObject
    }
  }

  func model(mappedFrom root: ResponseRoot) throws -> MockObject {
    return root.data.mock
  }
}

// MARK: - Array

struct MockJSONArrayCodableResource: JSONDecodableResourceType {
  typealias Model = [MockObject]
  typealias Root = Model
}

struct MockNestedJSONArrayCodableResource: JSONDecodableResourceType {
  typealias Model = [MockObject]

  struct ResponseRoot: Codable {
    let data: NestedData
    struct NestedData: Codable {
      let mocks: [MockObject]
    }
  }

  func model(mappedFrom root: ResponseRoot) throws -> [MockObject] {
    return root.data.mocks
  }
}

// swiftlint:enable nesting
