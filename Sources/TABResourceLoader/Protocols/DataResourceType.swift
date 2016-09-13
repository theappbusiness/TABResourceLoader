//
//  DataResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public protocol DataResourceType: ResourceType {
  func resultFrom(data: Data) -> Result<Model>
}