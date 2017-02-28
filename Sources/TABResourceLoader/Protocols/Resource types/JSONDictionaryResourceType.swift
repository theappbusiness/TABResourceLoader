//
//  JSONDictionaryResourceType.swift
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
 *  Defines a specific ResourceType used for JSON dictionary (i.e.[String : Any]) resources
 */
public protocol JSONDictionaryResourceType: DataResourceType {
  /**
   Parse this resources Model from a JSON dictionary

   - parameter jsonDictionary: The JSON dictionary to parse

   - returns: An instantiated model if parsing was succesful, otherwise nil
   */
  func model(from jsonDictionary: [String : Any]) -> Model?
}

extension JSONDictionaryResourceType {

  public func result(from data: Data) -> Result<Model> {
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
      return .failure(JSONParsingError.invalidJSONData)
    }

    guard let jsonDictionary = jsonObject as? [String: Any] else {
      return .failure(JSONParsingError.notAJSONDictionary)
    }

    guard let parsedResults = model(from: jsonDictionary) else {
      return .failure(JSONParsingError.cannotParseJSONDictionary)
    }

    return .success(parsedResults)
  }

}
