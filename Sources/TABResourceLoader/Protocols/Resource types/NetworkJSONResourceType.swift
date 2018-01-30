//
//  NetworkJSONResourceType.swift
//  TABResourceLoader
//
//  Created by John Sanderson on 30/01/2018.
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

/// Defines a resource that can be fetched from a network where the root type is a JSON array
public protocol NetworkJSONResourceType: NetworkResourceType {}

public extension NetworkJSONResourceType {
  var httpHeaderFields: [String: String]? {
    return ["Content-Type": "application/json"]
  }

  var bodyData: Data? {
    if let body = body {
      return try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
    }
    return nil
  }
}
