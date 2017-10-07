//
//  Product.swift
//  Example
//
//  Created by Sam Dods on 06/10/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import Foundation

struct Product: Decodable {
  let title: String
  let price: Double
  let imageURL: URL
}
