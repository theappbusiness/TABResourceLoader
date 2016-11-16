//
//  CitiesResource.swift
//  Example
//
//  Created by Luciano Marisi on 17/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
import TABResourceLoader

private let baseURL = URL(string: "http://localhost:8000/")!

struct CitiesResource: NetworkJSONDictionaryResourceType {
  typealias Model = [City]
  
  let url: URL
  
  init(continent: String) {
    url = baseURL.appendingPathComponent("\(continent).json")
  }
  
  // MARK: JSONDictionaryResourceType
  func model(from jsonDictionary: [String : Any]) -> Array<City>? {
    guard let
      citiesJSONArray = jsonDictionary["cities"] as? [[String: Any]]
      else {
        return []
    }
    return citiesJSONArray.flatMap(City.init)
  }
  
}
