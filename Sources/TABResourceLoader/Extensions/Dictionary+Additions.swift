//
//  Dictionary+Additions.swift
//  TABResourceLoader
//
//  Created by John Sanderson on 30/01/2018.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 The App Business

import Foundation

public extension Dictionary where Key == String, Value == CustomStringConvertible {

  /// Returns dictionary as string used to POST Form Data
  public var formDataPostString: String {
    return reduce(into: "") { (result, dictionaryEntry) in
      let parameter = dictionaryEntry.key + "=" + String(describing: dictionaryEntry.value)
      result += result.isEmpty ? parameter : "&" + parameter
    }
  }

}
