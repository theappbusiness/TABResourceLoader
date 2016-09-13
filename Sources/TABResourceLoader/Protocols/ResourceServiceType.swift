//
//  ResourceServiceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public protocol ResourceServiceType {
  associatedtype Resource: ResourceType

  /**
   Designated initialzer for constructing a ResourceServiceType
   */
  init()

  /**
   Fetch a resource

   - parameter resource:   The resource to fetch
   - parameter completion: A completion handler called with a Result type of the fetching computation
   */
  func fetch(resource: Resource, completion: @escaping (Result<Resource.Model>) -> Void)
}
