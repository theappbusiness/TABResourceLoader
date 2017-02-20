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

   - returns: An instantiated model if parsing was successful, otherwise throws
   */
  func model(from jsonArray: [Any]) throws -> Model
}

extension JSONArrayResourceType {

  public func model(from data: Data) throws -> Model {
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
      throw JSONParsingError.invalidJSONData
    }

    guard let jsonArray = jsonObject as? [Any] else {
      throw JSONParsingError.notAJSONArray
    }

    return try model(from: jsonArray)
  }

}
