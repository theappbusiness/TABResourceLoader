//
//  URLSessionType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 05/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

protocol URLSessionType {
  func perform(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: URLSessionType {
  public func perform(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    dataTask(with: request, completionHandler: completion).resume()
  }
}
