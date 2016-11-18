//
//  NetworkJSONArrayResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 02/11/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/// Defines a resource that can be fetched from a network where the root type is a JSON array
public protocol NetworkJSONArrayResourceType: NetworkResourceType, JSONArrayResourceType {}

public extension NetworkJSONArrayResourceType {
  var httpHeaderFields: [String: String]? {
    return ["Content-Type": "application/json"]
  }
}
