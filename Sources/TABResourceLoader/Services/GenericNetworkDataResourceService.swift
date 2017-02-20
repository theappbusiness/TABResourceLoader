//
//  GenericNetworkDataResourceService.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 11/02/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import Foundation

open class GenericNetworkDataResourceService<NetworkDataResource: NetworkResourceType & DataResourceType>: NetworkDataResourceService, ResourceServiceType {

  public typealias Resource = NetworkDataResource
  public typealias ResultType = NetworkResponse<Resource.Model>

  /// Designated initializer for NetworkDataResourceService, uses the shared URLSession
  public required init() {
    super.init(session: URLSession.shared)
  }

  /**
   Designated initializer for NetworkDataResourceService
   
   - parameter session: The session that will be used to make network requests.
   
   - returns: An new instance
   */
  public override init(session: URLSessionType) {
    super.init(session: session)
  }
}
