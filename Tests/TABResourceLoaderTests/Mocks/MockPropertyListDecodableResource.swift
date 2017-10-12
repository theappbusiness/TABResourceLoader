//
//  MockPropertyListDecodableResource.swift
//  TABResourceLoader
//
//  Created by Sam Dods on 06/10/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

// MARK: - Object

struct MockPropertyListDecodableResource: PropertyListDecodableResourceType {
  typealias Model = MockObject
  typealias Root = Model
}

struct MockNestedPropertyListDecodableResource: PropertyListDecodableResourceType {
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

struct MockPropertyListArrayDecodableResource: PropertyListDecodableResourceType {
  typealias Model = [MockObject]
  typealias Root = Model
}

struct MockNestedPropertyListArrayDecodableResource: PropertyListDecodableResourceType { // swiftlint:disable:this type_name
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
