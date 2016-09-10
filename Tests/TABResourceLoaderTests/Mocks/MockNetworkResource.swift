//
//  MockNetworkResource.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

struct MockNetworkResource: NetworkResourceType {
  typealias Model = String
  let url: NSURL
}