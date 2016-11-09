//
//  JSONParsingError.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/// Error for representing a failure while parsing JSON
///
/// - invalidJSONData: The JSON data is invalid
/// - notAJSONDictionary: The JSON provided is not a dictionary
/// - notAJSONArray: The JSON provided is not an array
/// - cannotParseJSONDictionary: Failed to create a Model from the JSON dictionary
/// - cannotParseJSONArray: Failed to create a Model from the JSON array
enum JSONParsingError: Error {
  case invalidJSONData
  case notAJSONDictionary
  case notAJSONArray
  case cannotParseJSONDictionary
  case cannotParseJSONArray
}
