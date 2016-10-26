//
//  JSONDictionaryResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 29/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/**
 *  Defines a specific ResourceType used for JSON dictionary (i.e.[String : Any]) resources
 */
public protocol JSONDictionaryResourceType: DataResourceType {
  /**
   Parse this resources Model from a JSON dictionary

   - parameter jsonDictionary: The JSON dictionary to parse

   - returns: An instantiated model if parsing was succesful, otherwise nil
   */
  func modelFrom(jsonDictionary: [String : Any]) -> Model?
}

extension JSONDictionaryResourceType {

  public func result(from data: Data) -> Result<Model> {
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
      return .failure(JSONParsingError.invalidJSONData)
    }

    guard let jsonDictionary = jsonObject as? [String: Any] else {
      return .failure(JSONParsingError.notAJSONDictionary)
    }

    guard let parsedResults = modelFrom(jsonDictionary: jsonDictionary) else {
      return .failure(JSONParsingError.cannotParseJSONDictionary)
    }

    return .success(parsedResults)
  }
  
}
