//
//  URLSessionType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 05/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

protocol URLSessionType {
  func performRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, NSError?) -> Void)
}

extension URLSession: URLSessionType {
  public func performRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, NSError?) -> Void) {
    dataTask(with: request, completionHandler: completion as! (Data?, URLResponse?, Error?) -> Void).resume()
  }
}
