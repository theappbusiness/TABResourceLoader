//
//  JSONDecodableResourceType.swift
//  TABResourceLoader
//
//  Created by Sam Dods on 06/10/2017.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Kin + Carta
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

/// Defines a specific ResourceType used for data that can be decoded from JSON format.
public protocol JSONDecodableResourceType: DataResourceType where Model: Decodable {

  /// This typealias represents the decodable object at the root of the response.
  /// This may match the model type, or the model may be nested within another decodable type.
  associatedtype Root: Decodable

  /// You may optionally provide a custom decoder. By default this is a new JSONDecoder() instance.
  var decoder: JSONDecoder { get }

  /// This optional method allows you to map from the root of the response to the model type to
  /// be returned by this resource. Your model type may be nested several levels deep, or even
  /// constructed from various objects within the root response.
  ///
  /// - Parameter root: The object at the root of the response.
  /// - Returns: The model object that has been mapped.
  /// - Throws: Throw an error if you cannot construct the model object to return.
  func model(mappedFrom root: Root) throws -> Model
}

extension JSONDecodableResourceType {

  /// Use a normal JSONDecoder by default, but allow customisation for dates, etc.
  public var decoder: JSONDecoder {
    return JSONDecoder()
  }

  /// implement the parsing method inherited from `DataResourceType`
  public func model(from data: Data) throws -> Model {
    let root = try decoder.decode(Root.self, from: data)
    return try model(mappedFrom: root)
  }
}

extension JSONDecodableResourceType where Model == Root {
  public func model(mappedFrom root: Root) throws -> Model {
    return root
  }
}
