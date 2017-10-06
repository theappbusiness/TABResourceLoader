//
//  ProductsResource.swift
//  Example
//
//  Created by Sam Dods on 06/10/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import Foundation
import TABResourceLoader

struct ProductsResource: NetworkJSONCodableResourceType {
  typealias Model = [Product]
  typealias TopLevel = Model
  
  let url = URL(string: "http://localhost:8000/products")!
}
