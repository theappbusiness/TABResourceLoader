//
//  City.swift
//  Example
//
//  Created by Luciano Marisi on 17/09/2016.
//  Copyright © 2016 Kin + Carta. All rights reserved.
//

import Foundation

struct City {
  let name: String
}

extension City {
  init?(jsonDictionary: [String: Any]) {
    guard let parsedName = jsonDictionary["name"] as? String else {
      return nil
    }
    name = parsedName
  }
}
