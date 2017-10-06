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

public protocol PropertyListCodableResourceType: DataResourceType where Model: Codable {
  associatedtype TopLevel: Codable
  var decoder: PropertyListDecoder { get }
  func modelFromTopLevel(_ topLevel: TopLevel) throws -> Model
}

public struct PropertyListModelNotFoundAtTopLevelError: Error {}

extension PropertyListCodableResourceType {

  /// Use a normal JSONDecoder by default, but allow customisation for dates, etc.
  public var decoder: PropertyListDecoder {
    return PropertyListDecoder()
  }

  /// implement the parsing method inherited from `DataResourceType`
  public func model(from data: Data) throws -> Model {
    let topLevel = try PropertyListDecoder().decode(TopLevel.self, from: data)
    return try modelFromTopLevel(topLevel)
  }

  public func modelFromTopLevel(_ topLevel: TopLevel) throws -> Model {
    guard let model = topLevel as? Model else {
      throw PropertyListModelNotFoundAtTopLevelError()
    }
    return model
  }
}
