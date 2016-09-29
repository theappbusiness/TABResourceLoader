//
//  NetworkJSONResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 28/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public protocol NetworkJSONResourceType: NetworkResourceType, JSONResourceType {}

public extension NetworkJSONResourceType {
  var HTTPHeaderFields: [String: String]? {
    return ["Content-Type": "application/json"]
  }
}
