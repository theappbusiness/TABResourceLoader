//
//  NetworkResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
  case GET
  case POST
  case PATCH
  case DELETE
  case HEAD
  case PUT
}

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
    urlComponents?.queryItems = queryItems

    guard let urlFromComponents = urlComponents?.url else { return nil }

    var request = URLRequest(url: urlFromComponents)
    request.allHTTPHeaderFields = HTTPHeaderFields
    request.httpMethod = HTTPRequestMethod.rawValue
    
    if let body = JSONBody {
      request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
    }

    return request
  }
}

public protocol NetworkJSONResourceType: NetworkResourceType, JSONResourceType {}
public protocol NetworkImageResourceType: NetworkResourceType, ImageResourceType {}

public extension NetworkJSONResourceType {
  var HTTPHeaderFields: [String: String]? {
    return ["Content-Type": "application/json"]
  }
}
