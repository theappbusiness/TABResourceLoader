//
//  ResourceOperationType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/// Define a type that is cancellable
public protocol Cancellable: class {
  /// Returns whether or not the type has been cancelled
  var cancelled: Bool { get }
}

public protocol Finishable: class {
  /**
   Method to be called when the type finished all it's work

   - parameter errors: Any error from the work done
   */
  func finish(_ errors: [NSError])
}

public protocol ResourceOperationType: Cancellable, Finishable {

  associatedtype ResourceService: ResourceServiceType
  
  /**
   Fetches a resource using the provided service

   - parameter resource: The resource to fetch
   - parameter service:  The service to be used for fetching the resource
   */
  func fetch(resource: ResourceService.Resource, usingService service: ResourceService)
  
  /**
   Called when the operation has finished, called on Main thread

   - parameter result: The result of the operation
   */
  func didFinishFetchingResource(result: Result<ResourceService.Resource.Model>)
}

public extension ResourceOperationType {
  
  func fetch(resource: ResourceService.Resource, usingService service: ResourceService) {
    if cancelled { return }
    service.fetch(resource: resource) { [weak self] (result) in
      Thread.rl_executeOnMain { [weak self] in
        guard let strongSelf = self else { return }
        if strongSelf.cancelled { return }
        strongSelf.didFinishFetchingResource(result: result)
        strongSelf.finish([])
      }
    }
  }
  
}
