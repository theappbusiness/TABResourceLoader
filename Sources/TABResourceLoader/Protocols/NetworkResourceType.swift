//
//  NetworkResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation


/// An enum representing the HTTP Method
public enum HTTPMethod: String {
  case GET
  case POST
  case PATCH
  case DELETE
  case HEAD
  case PUT
}

/// Defines a resource that can be fetched from a network
public protocol NetworkResourceType {
  /// The URL of the resource
  var url: URL { get }

  /// The HTTP method used to fetch this resource
  var HTTPRequestMethod: HTTPMethod { get }

  /// The HTTP header fields used to fetch this resource
  var HTTPHeaderFields: [String: String]? { get }

  /// The HTTP body as JSON used to fetch this resource
  var JSONBody: Any? { get }

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

  public var HTTPRequestMethod: HTTPMethod { return .GET }
  public var HTTPHeaderFields: [String: String]? { return [:] }
  public var JSONBody: Any? { return nil }
  public var queryItems: [URLQueryItem]? { return nil }

  public func urlRequest() -> URLRequest? {
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
    urlComponents?.queryItems = allQueryItems()

    guard let urlFromComponents = urlComponents?.url else { return nil }

    var request = URLRequest(url: urlFromComponents)
    request.allHTTPHeaderFields = HTTPHeaderFields
    request.httpMethod = HTTPRequestMethod.rawValue
    
    if let body = JSONBody {
      request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
    }

    return request
  }

  private func allQueryItems() -> [URLQueryItem] {
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
    var allQueryItems = [URLQueryItem]()

    if let componentsQueryItems = urlComponents?.queryItems {
      allQueryItems.append(contentsOf: componentsQueryItems)
    }

    if let queryItems = queryItems {
      allQueryItems.append(contentsOf: queryItems)
    }

    return allQueryItems
  }
}

public protocol NetworkImageResourceType: NetworkResourceType, ImageResourceType {}
