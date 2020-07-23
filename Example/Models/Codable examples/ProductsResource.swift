//
//  ProductsResource.swift
//  Example
//
//  Created by Sam Dods on 06/10/2017.
//  Copyright © 2017 Kin + Carta. All rights reserved.
//

import Foundation
import TABResourceLoader

struct ProductsResource: NetworkJSONDecodableResourceType {
  typealias Model = [Product]
  typealias Root = Model

  let url = URL(string: "http://localhost:8000/products")!
}
