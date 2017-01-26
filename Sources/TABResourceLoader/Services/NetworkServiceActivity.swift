//
//  NetworkServiceActivity.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 26/01/2017.
//  Copyright © 2017 Luciano Marisi. All rights reserved.
//

import Foundation

/// Type used to expose an API to listen to activity changes of network calls, i.e whether network 
// calls are being made or not
public struct NetworkServiceActivity {

  /// Set this property to listen to changes on the network activity status,
  /// useful for setting the isNetworkActivityIndicatorVisible on UIApplication for example
  public static var activityChangeHandler: ((_ isActive: Bool) -> ())?

  private static var numberOfActiveRequests = 0 {
    didSet {
      let hasOutstandingRequests = numberOfActiveRequests > 0
      activityChangeHandler?(hasOutstandingRequests)
    }
  }

  private static let serialQueue = DispatchQueue(label: "TABResourceLoader.NetworkServiceActivity.serialQueu")

  /// Call this method every time a request starts
  static func increaseActiveRequest() {
    serialQueue.sync {
      numberOfActiveRequests += 1
    }
  }
  
  /// Call this method every time a request ends
  static func decreaseActiveRequest() {
    serialQueue.sync {
      numberOfActiveRequests -= 1
    }
  }
}
