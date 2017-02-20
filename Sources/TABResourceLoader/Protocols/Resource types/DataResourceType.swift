//
//  DataResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public protocol DataResourceType: ResourceType {
  /**
   Parse this resources Model from some data

   - parameter data: The data to parse

   - returns: An instantiated model if parsing was successful, otherwise throws
   */
  func model(from data: Data) throws -> Model
}
