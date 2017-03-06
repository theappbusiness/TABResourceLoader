//
//  NetworkDataResourceService.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 05/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/// Enum representing an error from a network service
///
/// - couldNotCreateURLRequest: The URL request could be formed
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
      let parsedResult = Result<Resource.Model>.failure(NetworkResponseHandlerError.noDataProvided)
      completion(.failure(parsedResult, nil, NetworkServiceError.couldNotCreateURLRequest))
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
