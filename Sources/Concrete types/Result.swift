//
//  Result.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public enum Result<T> {
  case success(T)
  case failure(Error)
}

// http://www.cocoawithlove.com/blog/2016/08/21/result-types-part-one.html#conclusion-and-usage
extension Result {
  // Construct a `Result` from a Swift `throws` error handling function
  public init(_ capturing: () throws -> T) {
    do {
      self = .Success(try capturing())
    } catch {
      self = .Failure(error)
    }
  }
  
  // Convert the `Result` back to typical Swift `throws` error handling
  public func unwrap() throws -> T {
    switch self {
    case .Success(let v): return v
    case .Failure(let e): throw e
    }
  }
}

extension Result {
  
  /// Returns the success result if it exists, otherwise nil
  func successResult() -> T? {
    switch self {
    case .success(let successResult):
      return successResult
    case .failure:
      return nil
    }
  }
  
  /// Returns the error if it exists, otherwise nil
  func error() -> Error? {
    switch self {
    case .success:
      return nil
    case .failure(let error):
      return error
    }
  }
}
