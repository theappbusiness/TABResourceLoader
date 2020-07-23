//
//  MultipleResponseResource.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 22/02/2017.
//  Copyright © 2017 Kin + Carta. All rights reserved.
//

import Foundation
import TABResourceLoader

private let baseURL = URL(string: "http://localhost:8000/")!

struct MultipleResponseResource: NetworkJSONDictionaryResourceType {
  typealias Model = CitiesResponse

  let url: URL

  init(continent: String) {
    url = baseURL.appendingPathComponent("\(continent).json")
  }

  // MARK: JSONDictionaryResourceType
  func model(from jsonDictionary: [String: Any]) throws -> Model {
    return try CitiesResponse(jsonDictionary: jsonDictionary)
  }

}
