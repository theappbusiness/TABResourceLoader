//
//  MockDefaultNetworkDataResource.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 02/11/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

protocol NetworkDataResourceType: NetworkResourceType, DataResourceType {}

struct MockDefaultNetworkDataResource: NetworkDataResourceType {
  typealias Model = String
  let url: URL

  func model(from data: Data) throws -> String {
    return ""
  }
}
