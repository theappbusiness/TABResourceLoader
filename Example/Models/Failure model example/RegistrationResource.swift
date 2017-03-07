//
//  RegistrationResource.swift
//  TABResourceLoader
//
//  Created by Dean Brindley on 24/02/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import Foundation
import TABResourceLoader

private let baseURL = URL(string: "http://localhost:8000/")!

struct RegistrationParsingError: Error { }

enum RegistrationErrorType {
  case invalidEmailFormat
  case invalidPasswordFormat

  init(error: String) throws {
    switch error {
    case "RegisterUserErrorCodes.InvalidPasswordFormat":
      self = .invalidPasswordFormat
    case "RegisterUserErrorCodes.InvalidEmailFormat":
      self = .invalidEmailFormat
    default: throw RegistrationParsingError()
    }
  }

  var description: String {
    switch self {
    case .invalidEmailFormat:
      return "Please enter a valid email address"
    case .invalidPasswordFormat:
      return "Please enter a secure password"
    }
  }
}

enum RegistrationResult {
  case success(id: Int)
  case failure(type: RegistrationErrorType)
}

struct RegistrationResource: NetworkJSONDictionaryResourceType {
  typealias Model = RegistrationResult

  let url: URL

  init(emailAddress: String) {
    url = baseURL.appendingPathComponent("registration.json")
  }

  // MARK: JSONDictionaryResourceType
  func model(from jsonDictionary: [String : Any]) throws -> Model {
    if let error = jsonDictionary["errorCode"] as? String {
        let error = try RegistrationErrorType(error: error)
        return .failure(type: error)
    }

    return .success(id: 123)
  }

}
