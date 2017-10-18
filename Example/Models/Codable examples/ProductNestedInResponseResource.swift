//
//  ProductNestedInResponseResource.swift
//  Example
//
//  Created by Sam Dods on 06/10/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import Foundation
import TABResourceLoader

struct ProductNestedInResponseResource: NetworkJSONDecodableResourceType {
  typealias Model = Product

  struct TopLevelObject: Decodable {
    let data: NestedData
    struct NestedData: Decodable {
      let product: Product
    }
  }

  let url = URL(string: "http://localhost:8000/product/1234")!

  func model(mappedFrom root: TopLevelObject) throws -> Product {
    return root.data.product
  }
}
