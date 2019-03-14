//
//  CharacterSet+Additions.swift
//  TABResourceLoader
//
//  Created by Marco Guerrieri on 14/03/2019.
//  Copyright © 2019 Luciano Marisi. All rights reserved.
//

import Foundation

extension CharacterSet {
  public static var improvedUrlQueryAllowed: CharacterSet {
    var miniUrlQueryAllowed = CharacterSet.urlQueryAllowed
    miniUrlQueryAllowed.remove("&")
    miniUrlQueryAllowed.remove("=")
    return miniUrlQueryAllowed
  }
}
