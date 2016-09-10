//
//  ImageResource.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

//Used for the init and if we ever need to add headers.
struct NetworkImageResource: NetworkImageResourceType {
  typealias Model = UIImage
  let url: NSURL
}
