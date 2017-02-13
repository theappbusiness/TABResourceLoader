//
//  NetworkImageResource.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import UIKit

/**
 *  Concrete type that conforms to NetworkImageResourceType
 */
public struct NetworkImageResource: NetworkImageResourceType {
  public typealias Model = UIImage
  public let url: URL

  public init(url: URL) {
    self.url = url
  }
}
