//
//  NetworkDataResourceService.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 05/07/2016.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Luciano Marisi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

/// Enum representing an error from a network service
///
/// - couldNotCreateURLRequest: The URL request could not be formed
/// - noHTTPURLResponse:        No HTTPURLResponse exists
/// - sessionError:             The networking error returned by the URLSession
/// - statusCodeError:          A status code error between 400 and 600 (not including 600) was returned
/// - couldNotParseData:        The Data could not be parsed
public enum NetworkServiceError: Error {
  case couldNotCreateURLRequest
  case noHTTPURLResponse
  case sessionError(error: Error)
  case statusCodeError(statusCode: Int)
  case couldNotParseData(error: Error)
}

/// Object used to retrive types that conform to both @NetworkResourceType and DataResourceType
open class NetworkDataResourceService {

  /**
   Method designed to be implemented on subclasses, these fields will be overriden by any HTTP header field
   key that is defined in the resource (in case of conflicts)
   
   - returns: Return any additional header fields that need to be added to the url request
   */
  open func additionalHeaderFields() -> [String: String] {
    return [:]
  }

  let session: URLSessionType

  /**
   Designated initializer for NetworkDataResourceService
   
   - parameter session: The session that will be used to make network requests.
   
   - returns: An new instance
   */
  public init(session: URLSessionType = URLSession.shared) {
    self.session = session
  }

  deinit {
    session.invalidateAndCancel()
  }

  /**
   Fetches a resource conforming to both NetworkResourceType & DataResourceType
   
   - parameter resource:   The resource to fetch
   - parameter completion: A completion handler called with a Result type of the fetching computation
   */
  @discardableResult
  open func fetch<Resource: NetworkResourceType & DataResourceType>(resource: Resource, completion: @escaping (NetworkResponse<Resource.Model>) -> Void) -> Cancellable? {
    let cancellable = fetch(resource: resource, networkServiceActivity: NetworkServiceActivity.shared, completion: completion)
    return cancellable
  }

  // Method used for injecting the NetworkServiceActivity for testing
  @discardableResult
  func fetch<Resource: NetworkResourceType & DataResourceType>(resource: Resource, networkServiceActivity: NetworkServiceActivity, completion: @escaping (NetworkResponse<Resource.Model>) -> Void) -> Cancellable? {
    guard var urlRequest = resource.urlRequest() else {
      completion(.failure(parsingError: nil, .couldNotCreateURLRequest, nil))
      return nil
    }

    urlRequest.allHTTPHeaderFields = merge(additionalHeaderFields(), urlRequest.allHTTPHeaderFields)
    networkServiceActivity.increaseActiveRequest()
    let cancellable = session.perform(request: urlRequest) { (data, URLResponse, error) in
      networkServiceActivity.decreaseActiveRequest()
      let result = NetworkResponseHandler.resultFrom(resource: resource, data: data, URLResponse: URLResponse, error: error)
      completion(result)
    }
    return cancellable
  }

}
