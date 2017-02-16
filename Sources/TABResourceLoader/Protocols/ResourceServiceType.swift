//
//  ResourceServiceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/// Defines a type that can be cancelled
public protocol Cancellable: class {
  /// Cancels this task
  func cancel()
}

/// Defines a type that can fetch resources
public protocol ResourceServiceType {
  /// Defines the type of resource that this service fetches
  associatedtype Resource: ResourceType

  /// Defines the type of result that this service returns
  associatedtype ResultType

  /// Designated initialzer for constructing a ResourceServiceType
  init()

  /// Fetch a resource
  ///
  /// - Parameters:
  ///   - resource: The resource to fetch
  ///   - completion: A completion handler called with a Result type of the fetching computation
  /// - Returns: A cancellable type if it's possible to cancel the task created
  @discardableResult
  func fetch(resource: Resource, completion: @escaping (ResultType) -> Void) -> Cancellable?
}
