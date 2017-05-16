//
//  JSONArrayResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 29/09/2016.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Luciano Marisi
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
 *  Defines a specific ResourceType used for JSON array (i.e.[Any]) resources
 */
public protocol JSONArrayResourceType: DataResourceType {
  /**
   Parse this resources Model from a JSON array

   - parameter jsonArray: The JSON array to parse

   - returns: An instantiated model if parsing was successful, otherwise throws
   */
  func model(from jsonArray: [Any]) throws -> Model

  /**
   Optionally returns an error from the JSON array provided
   
   - parameter jsonArray: The JSON array to parse
   
   - returns: An error from the jsonArray
   */
  func error(from jsonArray: [Any]) -> Error?
}

extension JSONArrayResourceType {

  public func model(from data: Data) throws -> Model {
    let jsonArray = try self.jsonArray(from: data)
    return try model(from: jsonArray)
  }

  public func error(from data: Data) -> Error? {
    guard let jsonArray = try? self.jsonArray(from: data) else {
      return nil
    }
    return error(from: jsonArray)
  }

  private func jsonArray(from data: Data) throws -> [Any] {
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
      throw JSONParsingError.invalidJSONData
    }

    guard let jsonArray = jsonObject as? [Any] else {
      throw JSONParsingError.notAJSONArray
    }
    return jsonArray
  }

}

// No errors are returned by default
public extension JSONArrayResourceType {
  func error(from jsonArray: [Any]) -> Error? {
    return nil
  }
}
