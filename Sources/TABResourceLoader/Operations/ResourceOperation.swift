//
//  ResourceOperation.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/// Operation used for the sole purpose of fetching a resource using a service
public final class ResourceOperation<T: ResourceServiceType>: BaseAsynchronousOperation {

  public typealias ResourceService = T
  public typealias DidFinishFetchingResourceCallback = (ResourceOperation<ResourceService>, Result<ResourceService.Resource.Model>) -> Void

  // These properties are internal for unit testing purposes
  let resource: ResourceService.Resource
  let service: ResourceService
  let didFinishFetchingResourceCallback: DidFinishFetchingResourceCallback

  /// Designated initializer
  ///
  /// - parameter resource:                          The resource to fetch using this operation
  /// - parameter service:                           The service to be used to fetch the resource
  /// - parameter didFinishFetchingResourceCallback: The closure to be executed when the resource has been fetch but before the operation is finished
  ///
  /// - returns: A new instance of the ResourceOperation
  public init(resource: ResourceService.Resource, service: ResourceService = ResourceService(session: URLSession.shared), didFinishFetchingResourceCallback: @escaping DidFinishFetchingResourceCallback) {
    self.resource = resource
    self.service = service
    self.didFinishFetchingResourceCallback = didFinishFetchingResourceCallback
    super.init()
  }

  /// Creates a shallow copy of this operation, reuse the original instance of the service, 
  /// the resource and the didFinishFetchingResourceCallback
  ///
  /// - returns: A new ResourceOperation
  public func createCopy() -> ResourceOperation<ResourceService> {
    return ResourceOperation(resource: resource, service: service, didFinishFetchingResourceCallback: didFinishFetchingResourceCallback)
  }

  override public func execute() {
    if isCancelled { return }
    service.fetch(resource: resource, completion: handleFetchCompletion)
  }

  private func handleFetchCompletion(with result: Result<ResourceService.Resource.Model>) {
    Thread.rl_executeOnMain { [weak self] in
      guard let strongSelf = self else { return }
      if strongSelf.isCancelled { return }
      strongSelf.didFinishFetchingResourceCallback(strongSelf, result)
      strongSelf.finish()
    }
  }

}
