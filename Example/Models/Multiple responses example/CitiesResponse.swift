//
//  CitiesResponse.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 22/02/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import Foundation

enum CitiesResponseError: Error {
  case parsingFailed
}

enum CitiesResponse {
  case cities([City])
  case city(City)
  case serverError(ServerError)
}

extension CitiesResponse {
  public init(jsonDictionary: [String : Any]) throws {
    if let citiesJSONArray = jsonDictionary["cities"] as? [[String: Any]] {
      self = .cities(citiesJSONArray.compactMap(City.init))
    } else if let city = City(jsonDictionary: jsonDictionary) {
      self = .city(city)
    } else if let serverError = ServerError(jsonDictionary: jsonDictionary) {
      self = .serverError(serverError)
    } else {
      throw CitiesResponseError.parsingFailed
    }
  }
}
