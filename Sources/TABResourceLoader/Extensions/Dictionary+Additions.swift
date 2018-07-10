//
//  Dictionary+Additions.swift
//  TABResourceLoader
//
//  Created by John Sanderson on 30/01/2018.
//  Copyright © 2018 Luciano Marisi. All rights reserved.
//

import Foundation

public extension Dictionary where Key == String, Value == CustomStringConvertible {

  /// Returns dictionary as string used to POST Form Data
  public var formDataPostString: String {
    var data = [String]()
    forEach { (key, value) in
      let stringValue = String(describing: value)
      data.append(key + "=" + stringValue)
    }
    return data.map(String.init(_:)).joined(separator: "&")
  }

}
