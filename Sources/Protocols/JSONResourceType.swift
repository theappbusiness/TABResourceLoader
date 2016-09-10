//
//  JSONResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/**
 *  Protocol used to define a resource, contains an associated type that is the domain specific model type
 */
public protocol ResourceType {
  associatedtype Model
}

/**
 *  Defines a specific ResourceType used for JSON resources
 */
public protocol JSONResourceType: DataResourceType {
  func modelFrom(jsonDictionary: [String : AnyObject]) -> Model?
  func modelFrom(jsonArray: [AnyObject]) -> Model?
}

// MARK: - Parsing defaults
extension JSONResourceType {
  /**
   Parse this resources Model from a JSON dictionary

   - parameter jsonDictionary: The JSON dictionary to parse

   - returns: An instantiated model if parsing was succesful, otherwise nil
   */
  public func modelFrom(jsonDictionary: [String : AnyObject]) -> Model? { return nil }

  /**
   Parse this resources Model from a JSON array

   - parameter jsonArray: The JSON array to parse

   - returns: An instantiated model if parsing was succesful, otherwise nil
   */
  public func modelFrom(jsonArray: [AnyObject]) -> Model? { return nil }
}

enum JSONParsingError: Error {
  case invalidJSONData
  case cannotParseJSONDictionary
  case cannotParseJSONArray
  case unsupportedType
}

// MARK: - Convenince parsing functions
extension JSONResourceType {

  public func resultFrom(data: Data) -> Result<Model> {
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
      return .failure(JSONParsingError.invalidJSONData)
    }

    if let jsonDictionary = jsonObject as? [String: AnyObject] {
      return resultFrom(jsonDictionary: jsonDictionary)
    }

    if let jsonArray = jsonObject as? [AnyObject] {
      return resultFrom(jsonArray: jsonArray)
    }

    // This is likely an impossible case since `JSONObjectWithData` likely only returns [String: AnyObject] or [AnyObject] but still needed to appease the compiler
    return .failure(JSONParsingError.unsupportedType)
  }

  fileprivate func resultFrom(jsonDictionary: [String: AnyObject]) -> Result<Model> {
    guard let parsedResults = modelFrom(jsonDictionary: jsonDictionary) else {
      return .failure(JSONParsingError.cannotParseJSONDictionary)
    }
    return .success(parsedResults)
  }

  fileprivate func resultFrom(jsonArray: [AnyObject]) -> Result<Model> {
    guard let parsedResults = modelFrom(jsonArray: jsonArray) else {
      return .failure(JSONParsingError.cannotParseJSONArray)
    }
    return .success(parsedResults)
  }

}
