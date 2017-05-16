//
//  NetworkResponseHandler.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 11/02/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import Foundation

/// Enum representing the response from a network request
///
/// ---
/// # Success case
///
/// Defines a response that succeeded containing:
///   - The parsed model
///   - The HTTPURLResponse
///
/// ## A success will meet all the following conditions:
///   - The parsing succeeds
///   - The HTTP status code is not 4xx or 5xx
///   - No error returned from URLSession
///
/// ---
/// # Failure case
///
/// Defines a response that failed, contains:
///   - The Result of parsing the model, success case contains the model and failure case contains the parsing error
///   - A HTTPURLResponse if it exists
///   - A NetworkServiceError
///
/// ## Reasons for failure can be (in order):
///   1. No HTTPURLResponse with a URLSession error
///   2. No HTTPURLResponse without a URLSession error (This can only be possible for non HTTP responses)
///   3. The HTTP status code is 4xx or 5xx
///   4. A URLSession error exists
///   5. Could not parse the data
public enum NetworkResponse<ParsedType> {
  case success(ParsedType, HTTPURLResponse)
  case failure(Result<ParsedType>, HTTPURLResponse?, NetworkServiceError)
}

public enum NetworkResponseMultipleError<Model> {
  case success(Model, HTTPURLResponse)
  case failure(parsingError: Error, NetworkServiceError, HTTPURLResponse?)
}

public enum NetworkResponseSingleError<Model> {
  case success(Model, HTTPURLResponse)
  case failure(Error, HTTPURLResponse?)
}

enum NetworkResponseHandlerError: Error {
  case noDataProvided
}

public protocol ErrorResourceType {
  func error(from data: Data) -> Error?
}

struct NetworkResponseHandler {

  static func errorableResultFrom<Resource: NetworkResourceType & DataResourceType & ErrorResourceType>(resource: Resource, data: Data?, URLResponse: Foundation.URLResponse?, error: Error?) -> NetworkResponseSingleError<Resource.Model> {
    guard let data = data else {
      return NetworkResponseSingleError.failure(NetworkResponseHandlerError.noDataProvided, URLResponse as? HTTPURLResponse)
    }
    if let error = resource.error(from: data) {
      return NetworkResponseSingleError.failure(error, URLResponse as? HTTPURLResponse)
    }
    return resultFrom(resource: resource, data: data, URLResponse: URLResponse, error: error)

  }

  static func resultFrom<Resource: NetworkResourceType & DataResourceType>(resource: Resource, data: Data?, URLResponse: Foundation.URLResponse?, error: Error?) -> NetworkResponseSingleError<Resource.Model> {
    guard let data = data else {
      return NetworkResponseSingleError.failure(NetworkResponseHandlerError.noDataProvided, URLResponse as? HTTPURLResponse)
    }

    guard let HTTPURLResponse = URLResponse as? HTTPURLResponse else {
      if let error = error {
        return .failure(NetworkServiceError.sessionError(error: error), nil)
      } else {
        return .failure(NetworkServiceError.noHTTPURLResponse, nil)
      }
    }

    switch HTTPURLResponse.statusCode {
    case 400..<600:
      return .failure(NetworkServiceError.statusCodeError(statusCode: HTTPURLResponse.statusCode), HTTPURLResponse)
    default: break
    }

    if let error = error {
      return .failure(NetworkServiceError.sessionError(error: error), HTTPURLResponse)
    }

    let parsedResult = Result<Resource.Model> {
      return try resource.model(from: data)
    }
    switch parsedResult {
    case .success(let model):
      return .success(model, HTTPURLResponse)
    case .failure(let parsingError):
       return .failure(parsingError, HTTPURLResponse)
    }
  }

}
