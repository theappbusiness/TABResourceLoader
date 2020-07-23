//
//  ErrorModel.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 22/02/2017.
//  Copyright © 2017 Kin + Carta. All rights reserved.
//

import Foundation

struct ServerError {
  let errorMessage: String
}

extension ServerError {
  init?(jsonDictionary: [String: Any]) {
    guard let parsedErrorMessage = jsonDictionary["errorMessage"] as? String else {
      return nil
    }
    errorMessage = parsedErrorMessage
  }
}
