//
//  NetworkResponseHandler.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 11/02/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import Foundation

struct NetworkResponseHandler {

  static func resultFrom<Resource: NetworkResourceType & DataResourceType>(resource: Resource, data: Data?, URLResponse: Foundation.URLResponse?, error: Error?) -> Result<Resource.Model> {

    if let HTTPURLResponse = URLResponse as? HTTPURLResponse {
      switch HTTPURLResponse.statusCode {
      case 400..<600:
        return .failure(NetworkServiceError.statusCodeError(statusCode: HTTPURLResponse.statusCode))
      default: break
      }
    }

    if let error = error {
      return .failure(NetworkServiceError.networkingError(error: error))
    }

    guard let data = data else {
      return .failure(NetworkServiceError.noData)
    }

    do {
      let model = try resource.model(from: data)
      return .success(model)
    } catch {
      return .failure(NetworkServiceError.networkingError(error: error))
    }
  }
}
