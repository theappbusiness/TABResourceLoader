//
//  NetworkJSONResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 28/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

@available(*, deprecated: 2.1.0, message: "Use NetworkJSONDictionaryResourceType or NetworkJSONArrayResourceType")
public protocol NetworkJSONResourceType: NetworkResourceType, JSONResourceType {}

public extension NetworkJSONResourceType {
  var HTTPHeaderFields: [String: String]? {
    return ["Content-Type": "application/json"]
  }
}

/// Defines a resource that can be fetched from a network where the root type is a JSON object
public protocol NetworkJSONDictionaryResourceType: NetworkResourceType, JSONDictionaryResourceType {}

public extension NetworkJSONDictionaryResourceType {
  var HTTPHeaderFields: [String: String]? {
    return ["Content-Type": "application/json"]
  }
}

/// Defines a resource that can be fetched from a network where the root type is a JSON array
public protocol NetworkJSONArrayResourceType: NetworkResourceType, JSONArrayResourceType {}

public extension NetworkJSONArrayResourceType {
  var HTTPHeaderFields: [String: String]? {
    return ["Content-Type": "application/json"]
  }
}
