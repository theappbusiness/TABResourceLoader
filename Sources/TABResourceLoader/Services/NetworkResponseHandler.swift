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
///   - Contains the error produced when attempting to parse the Model
///   - A HTTPURLResponse if it exists
///   - A NetworkServiceError
///
/// ## Reasons for failure can be (in order):
///   1. No HTTPURLResponse with a URLSession error
///   2. No HTTPURLResponse without a URLSession error (This can only be possible for non HTTP responses)
///   3. The HTTP status code is 4xx or 5xx
///   4. A URLSession error exists
///   5. Could not parse the data
public enum NetworkResponse<Model> {
  case success(Model, HTTPURLResponse)
  case failure(parsingError: Error?, NetworkServiceError, HTTPURLResponse?)
}

enum NetworkResponseHandlerError: Error {
  case noDataProvided
}

struct NetworkResponseHandler {

  static func resultFrom<Resource: NetworkResourceType & DataResourceType>(resource: Resource, data: Data?, URLResponse: Foundation.URLResponse?, error: Error?) -> NetworkResponse<Resource.Model> {

    guard let HTTPURLResponse = URLResponse as? HTTPURLResponse else {
      if let error = error {
        return NetworkResponse.failure(parsingError: nil, .sessionError(error: error), nil)
      } else {
        return NetworkResponse.failure(parsingError: nil, .noHTTPURLResponse, nil)
      }
    }

    guard let data = data else {
      let networkError: NetworkServiceError = self.networkServiceError(HTTPURLResponse: HTTPURLResponse, error: error) ?? .couldNotParseData(error: NetworkResponseHandlerError.noDataProvided)
      return NetworkResponse.failure(parsingError: nil, networkError, URLResponse as? HTTPURLResponse)
    }

    let parsedResult = Result<Resource.Model> {
      return try resource.model(from: data)
    }

    switch parsedResult {
    case .success(let model):
      return .success(model, HTTPURLResponse)
    case .failure(let parsingError):
      let networkError: NetworkServiceError = self.networkServiceError(HTTPURLResponse: HTTPURLResponse, error: error) ?? .couldNotParseData(error: parsingError)
      return .failure(parsingError: parsingError, networkError, HTTPURLResponse)
    }
  }

  private static func networkServiceError(HTTPURLResponse: HTTPURLResponse, error: Error?) -> NetworkServiceError? {
    switch HTTPURLResponse.statusCode {
    case 400..<600:
      return .statusCodeError(statusCode: HTTPURLResponse.statusCode)
    default: break
    }

    if let error = error {
      return .sessionError(error: error)
    }
    return nil
  }

}
