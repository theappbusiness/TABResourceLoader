//
//  CommonFunctions.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 11/02/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import Foundation

/// Merges two [String: String] dictionaries. For common keys, the values of the right dictionary take precedence
///
/// - Parameters:
///   - left:  The dictionary to use as a base
///   - right: The dictionary used to append to the base, if a key from this dictionary exists in the base,
///            the value from this dictionary will be used
/// - Returns: Returns the merged dictionary or nil if both dictionary are nil
func merge(_ left: [String: String]?, _ right: [String: String]?) -> [String: String]? {
  if left == nil && right == nil { return nil }
  var mergedValues = left ?? [:]
  if let right = right {
    for (key, value) in right {
      mergedValues[key] = value
    }
  }
  return mergedValues
}
