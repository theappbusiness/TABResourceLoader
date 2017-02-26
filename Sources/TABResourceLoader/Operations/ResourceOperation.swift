//
//  ResourceOperation.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Luciano Marisi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

/// Operation used for the sole purpose of fetching a resource using a service
public final class ResourceOperation<ResourceService: ResourceServiceType>: BaseAsynchronousOperation {

  public typealias DidFinishFetchingResourceCallback = (ResourceOperation<ResourceService>, Result<ResourceService.Resource.Model>) -> Void

  // These properties are internal for unit testing purposes
  let resource: ResourceService.Resource
  let service: ResourceService
  let didFinishFetchingResourceCallback: DidFinishFetchingResourceCallback
  weak private(set) var cancellable: Cancellable? // Operation should not retain the cancellable item as it does not own it

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
    cancellable = service.fetch(resource: resource, completion: handleFetchCompletion)
  }

  public override func cancel() {
    cancellable?.cancel()
    super.cancel()
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
