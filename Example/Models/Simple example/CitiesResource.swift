//
//  CitiesResource.swift
//  Example
//
//  Created by Luciano Marisi on 17/09/2016.
//  Copyright © 2016 Kin + Carta. All rights reserved.
//

import Foundation
import TABResourceLoader

private let baseURL = URL(string: "http://localhost:8000/")!

enum CitiesResourceError: Error {
  case parsingFailed
}

struct CitiesResource: NetworkJSONDictionaryResourceType {
  typealias Model = [City]

  let url: URL

  init(continent: String) {
    url = baseURL.appendingPathComponent("\(continent).json")
  }

  // MARK: JSONDictionaryResourceType
  func model(from jsonDictionary: [String: Any]) throws -> Model {
    guard let
      citiesJSONArray = jsonDictionary["cities"] as? [[String: Any]]
      else {
        throw CitiesResourceError.parsingFailed
    }
    return citiesJSONArray.compactMap(City.init)
  }

}
