//
//  NetworkDataResourceService.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 05/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/**
 Enum representing an error from a network service

 - CouldNotCreateURLRequest: The URL request could be formed
 - StatusCodeError:          A status code error between 400 and 600 (not including 600) was returned
 - NetworkingError:          Any other networking error
 - NoData:                   No data was returned
 */
public enum NetworkServiceError: Error {
  case couldNotCreateURLRequest
  case statusCodeError(statusCode: Int, data: Data?)
  case networkingError(error: Error)
  case noData
}

open class NetworkDataResourceService<NetworkDataResource: NetworkResourceType & DataResourceType>: ResourceServiceType {

  public typealias Resource = NetworkDataResource

  /**
   Method designed to be implemented on subclasses, these fields will be overriden by any HTTP header field
   key that is defined in the resource (in case of conflicts)
   
   - returns: Return any additional header fields that need to be added to the url request
   */
  open func additionalHeaderFields() -> [String: String] {
    return [:]
  }
  
  public let session: URLSessionType
  
  /**
   Designated initializer for NetworkDataResourceService
   
   - parameter session: The session that will be used to make network requests.
   
   - returns: An new instance
   */
  public required init(session: URLSessionType = URLSession.shared) {
    self.session = session
  }

  open func fetch(resource: Resource, completion: @escaping (Result<Resource.Model>) -> Void) {
    fetch(resource: resource, networkServiceActivity: NetworkServiceActivity.shared, completion: completion)
  }

  // Method used for injecting the NetworkServiceActivity for testing
  final func fetch(resource: Resource, networkServiceActivity: NetworkServiceActivity, completion: @escaping (Result<Resource.Model>) -> Void) {
    guard var urlRequest = resource.urlRequest() else {
      completion(.failure(NetworkServiceError.couldNotCreateURLRequest))
      return
    }
    
    urlRequest.allHTTPHeaderFields = allHTTPHeaderFields(resourceHTTPHeaderFields: urlRequest.allHTTPHeaderFields)
    networkServiceActivity.increaseActiveRequest()
    session.perform(request: urlRequest) { [weak self] (data, URLResponse, error) in
      networkServiceActivity.decreaseActiveRequest()
      guard let strongSelf = self else { return }
      completion(strongSelf.resultFrom(resource: resource, data: data, URLResponse: URLResponse, error: error))
    }
  }
  
  fileprivate func allHTTPHeaderFields(resourceHTTPHeaderFields: [String: String]?) -> [String: String]? {
    var generalHTTPHeaderFields = additionalHeaderFields()
    if let resourceHTTPHeaderFields = resourceHTTPHeaderFields {
      for (key, value) in resourceHTTPHeaderFields {
        generalHTTPHeaderFields[key] = value
      }
    }
    return generalHTTPHeaderFields
  }
  
  fileprivate func resultFrom(resource: Resource, data: Data?, URLResponse: Foundation.URLResponse?, error: Error?) -> Result<Resource.Model> {
    
    if let HTTPURLResponse = URLResponse as? HTTPURLResponse {
      switch HTTPURLResponse.statusCode {
      case 400..<600:
        return .failure(NetworkServiceError.statusCodeError(statusCode: HTTPURLResponse.statusCode, data: data))
      default: break
      }
    }
    
    if let error = error {
      return .failure(NetworkServiceError.networkingError(error: error))
    }
    
    guard let data = data else {
      return .failure(NetworkServiceError.noData)
    }
    
    return resource.result(from: data)
  }
  
}
