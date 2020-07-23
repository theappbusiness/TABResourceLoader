//
//  JSONDictionaryResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 29/09/2016.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Kin + Carta
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

/**
 *  Defines a specific ResourceType used for JSON dictionary (i.e.[String : Any]) resources
 */
public protocol JSONDictionaryResourceType: DataResourceType {
  /**
   Parse this resources Model from a JSON dictionary

   - parameter jsonDictionary: The JSON dictionary to parse

   - returns: An instantiated model if parsing was successful, otherwise throws
   */
  func model(from jsonDictionary: [String: Any]) throws -> Model

  /**
   Optionally returns an error from the JSON dictionary provided
   
   - parameter jsonDictionary: The JSON dictionary to parse
   
   - returns: An error from the jsonDictionary
   */
  func error(from jsonDictionary: [String: Any]) -> Error?
}

extension JSONDictionaryResourceType {

  public func model(from data: Data) throws -> Model {
    let jsonDictionary = try self.jsonDictionary(from: data)
    return try model(from: jsonDictionary)
  }

  public func error(from data: Data) -> Error? {
    guard let jsonDictionary = try? self.jsonDictionary(from: data) else {
      return nil
    }
    return error(from: jsonDictionary)
  }

  public func jsonDictionary(from data: Data) throws ->  [String: Any] {
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
      throw JSONParsingError.invalidJSONData
    }

    guard let jsonDictionary = jsonObject as? [String: Any] else {
      throw JSONParsingError.notAJSONDictionary
    }

    return jsonDictionary
  }

}

// No errors are returned by default
public extension JSONDictionaryResourceType {
  func error(from jsonDictionary: [String: Any]) -> Error? {
    return nil
  }
}
