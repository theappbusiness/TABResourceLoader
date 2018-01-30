//
//  Dictionary+Additions.swift
//  TABResourceLoader
//
//  Created by John Sanderson on 30/01/2018.
//  Copyright © 2018 Luciano Marisi. All rights reserved.
//

import Foundation

public extension Dictionary where Key == String, Value == Any {

  /// Returns dictionary as string used to POST Form Data
  public var formDataPostString: String {
    var data = [String]()
    self.forEach { (key, value) in
      data.append(key + "=\(value)")
    }
    return data.map { String($0) }.joined(separator: "&")
  }

}
