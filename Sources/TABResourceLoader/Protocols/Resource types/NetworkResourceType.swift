//
//  NetworkResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
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

/// An enum representing the HTTP Method
public enum HTTPMethod: String {
  case get
  case post
  case patch
  case delete
  case head
  case put

  public var rawValue: String {
    return "\(self)".uppercased()
  }
}

/// Defines a resource that can be fetched from a network
public protocol NetworkResourceType {
  /// The URL of the resource
  var url: URL { get }

  /// The HTTP method used to fetch this resource
  var httpRequestMethod: HTTPMethod { get }

  /// The HTTP header fields used to fetch this resource
  var httpHeaderFields: [String: String]? { get }

  /// The HTTP body as Data used to fetch this resource
  var bodyData: Data? { get }

  /// The query items to be added to the url to fetch this resource
  var queryItems: [URLQueryItem]? { get }

  /**
   Convenience function that builds a URLRequest for this resource

   - returns: A URLRequest or nil if the construction of the request failed
   */
  func urlRequest() -> URLRequest?
}

// MARK: - NetworkJSONResource defaults
public extension NetworkResourceType {

  public var httpRequestMethod: HTTPMethod { return .get }
  public var httpHeaderFields: [String: String]? { return [:] }
  public var bodyData: Data? { return nil }
  public var queryItems: [URLQueryItem]? { return nil }

  public func urlRequest() -> URLRequest? {
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
    let initialItems = urlComponents?.queryItems
    urlComponents?.queryItems = allQueryItems(initialItems: initialItems)

    guard let urlFromComponents = urlComponents?.url else { return nil }

    var request = URLRequest(url: urlFromComponents)
    request.allHTTPHeaderFields = httpHeaderFields
    request.httpMethod = httpRequestMethod.rawValue
    request.httpBody = bodyData

    return request
  }

  private func allQueryItems(initialItems: [URLQueryItem]?) -> [URLQueryItem]? {
    let combinedQueryItems = (initialItems ?? []) + (queryItems ?? [])
    let allQueryItems = combinedQueryItems.isEmpty ? nil : combinedQueryItems
    return allQueryItems
  }
}

public protocol NetworkImageResourceType: NetworkResourceType, ImageResourceType {}
