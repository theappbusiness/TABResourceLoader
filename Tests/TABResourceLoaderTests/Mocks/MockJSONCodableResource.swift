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
  typealias TopLevel = Model
}

struct MockNestedJSONCodableResource: JSONDecodableResourceType {
  typealias Model = MockObject

  struct TopLevelObject: Codable {
    let data: NestedData
    struct NestedData: Codable {
      let mock: MockObject
    }
  }

  func modelFromTopLevel(_ topLevel: TopLevelObject) throws -> MockObject {
    return topLevel.data.mock
  }
}

// MARK: - Array

struct MockJSONArrayCodableResource: JSONDecodableResourceType {
  typealias Model = [MockObject]
  typealias TopLevel = Model
}

struct MockNestedJSONArrayCodableResource: JSONDecodableResourceType {
  typealias Model = [MockObject]

  struct TopLevelObject: Codable {
    let data: NestedData
    struct NestedData: Codable {
      let mocks: [MockObject]
    }
  }

  func modelFromTopLevel(_ topLevel: TopLevelObject) throws -> [MockObject] {
    return topLevel.data.mocks
  }
}

// MARK: - Invalid

// The following is invalid because it declares a different type of top level
// object, but doesn't provide the mapping between TopLevel and Model.
struct MockJSONCodableInvalidResource: JSONDecodableResourceType {
  typealias Model = [MockObject]
  typealias TopLevel = TopLevelObject

  struct TopLevelObject: Codable {
    let data: NestedData
    struct NestedData: Codable {
      let mock: MockObject
    }
  }
}

// swiftlint:enable nesting
