//
//  ResourceOperation.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public final class ResourceOperation<ResourceService: ResourceServiceType>: BaseAsynchronousOperation, ResourceOperationType {

  public typealias Resource = ResourceService.Resource
  public typealias DidFinishFetchingResourceCallback = (ResourceOperation<ResourceService>, Result<Resource.Model>) -> Void

  private let resource: Resource
  private let service: ResourceService
  private let didFinishFetchingResourceCallback: DidFinishFetchingResourceCallback

  public init(resource: ResourceService.Resource, service: ResourceService = ResourceService(), didFinishFetchingResourceCallback: DidFinishFetchingResourceCallback) {
    self.resource = resource
    self.service = service
    self.didFinishFetchingResourceCallback = didFinishFetchingResourceCallback
    super.init()
  }

  override public func execute() {
    fetch(resource: resource, usingService: service)
  }

  public func didFinishFetchingResource(result result: Result<Resource.Model>) {
    didFinishFetchingResourceCallback(self, result)
  }
  
}
