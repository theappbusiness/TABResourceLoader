//
//  ProductNestedInResponseResource.swift
//  Example
//
//  Created by Sam Dods on 06/10/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import Foundation
import TABResourceLoader

struct ProductNestedInResponseResource: NetworkJSONCodableResourceType {
  typealias Model = Product
  typealias TopLevel = Model
  
  struct TopLevelObject: Codable {
    let data: NestedData
    struct NestedData: Codable {
      let product: Product
    }
  }
  
  let url = URL(string: "http://localhost:8000/product/1234")!
  
  func modelFromTopLevel(_ topLevel: TopLevelObject) throws -> Product {
    return topLevel.data.product
  }
}
