//
//  URLSessionType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 05/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

protocol URLSessionType {
  func performRequest(request: NSURLRequest, completion: (NSData?, NSURLResponse?, NSError?) -> Void)
}

extension NSURLSession: URLSessionType {
  public func performRequest(request: NSURLRequest, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
    dataTaskWithRequest(request, completionHandler: completion).resume()
  }
}
