//
//  URLSessionType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 05/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public protocol URLSessionType {
  func perform(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
  func invalidateAndCancel()
}

extension URLSession: URLSessionType {
  public func perform(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    let task = dataTask(with: request, completionHandler: completion)
    task.resume()
    return task
  }
}

extension URLSessionDataTask: Cancellable {}
