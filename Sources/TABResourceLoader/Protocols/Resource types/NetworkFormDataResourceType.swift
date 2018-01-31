//
//  NetworkFormDataResourceType.swift
//  TABResourceLoader
//
//  Created by John Sanderson on 30/01/2018.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 The App Business
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

/// Defines a resource that can be used to POST form data to a network
public protocol NetworkFormDataResourceType: NetworkResourceType, DataResourceType {

  /// The form data body used to fetch this resource
  var formDataBody: Any? { get }
}

public extension NetworkFormDataResourceType {
  var formDataBody: Any? { return nil }

  var httpRequestMethod: HTTPMethod {
    return .post
  }

  var httpHeaderFields: [String: String]? {
    return ["Content-Type": "application/x-www-form-urlencoded"]
  }

  var bodyData: Data? {
    if let body = formDataBody as? [String: Any] {
      return body.formDataPostString.data(using: .utf8)
    }
    return nil
  }
}
