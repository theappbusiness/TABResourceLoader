//
//  MockNetworkResource.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

struct MockNetworkResource: NetworkResourceType {
  typealias Model = String
  let url: URL
}
