//
//  JSONArrayResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 29/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/**
 *  Defines a specific ResourceType used for JSON array (i.e.[Any]) resources
 */
public protocol JSONArrayResourceType: DataResourceType {
  /**
   Parse this resources Model from a JSON array

   - parameter jsonArray: The JSON array to parse

   - returns: An instantiated model if parsing was succesful, otherwise nil
   */
  func model(from jsonArray: [Any]) -> Model?
}

extension JSONArrayResourceType {

  public func result(from data: Data) -> Result<Model> {
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
      return .failure(JSONParsingError.invalidJSONData)
    }

    guard let jsonArray = jsonObject as? [Any] else {
      return .failure(JSONParsingError.notAJSONArray)
    }

    guard let parsedResults = model(from: jsonArray) else {
      return .failure(JSONParsingError.cannotParseJSONArray)
    }

    return .success(parsedResults)
  }

}
