//
//  NetworkJSONDictionaryResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 28/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/// Defines a resource that can be fetched from a network where the root type is a JSON object
public protocol NetworkJSONDictionaryResourceType: NetworkResourceType, JSONDictionaryResourceType {}

public extension NetworkJSONDictionaryResourceType {
  var httpHeaderFields: [String: String]? {
    return ["Content-Type": "application/json"]
  }
}


