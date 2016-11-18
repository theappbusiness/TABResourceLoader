//
//  ResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 02/11/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/**
 *  Protocol used to define a resource, contains an associated type that is the domain specific model type
 */
public protocol ResourceType {
  associatedtype Model
}
