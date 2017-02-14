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
public class NetworkServiceActivity {

  /// Set this property to listen to changes on the network activity status,
  /// useful for setting the isNetworkActivityIndicatorVisible on UIApplication for example
  public static var activityChangeHandler: ((_ isActive: Bool) -> Void)?

  static let shared = NetworkServiceActivity()

  private(set)var numberOfActiveRequests = 0 {
    didSet {
      let hasOutstandingRequests = numberOfActiveRequests > 0
      NetworkServiceActivity.activityChangeHandler?(hasOutstandingRequests)
    }
  }

  private let serialQueue = DispatchQueue(label: "TABResourceLoader.NetworkServiceActivity.serialQueue")

  /// Call this method every time a request starts
  func increaseActiveRequest() {
    serialQueue.sync {
      numberOfActiveRequests += 1
    }
  }

  /// Call this method every time a request ends
  func decreaseActiveRequest() {
    serialQueue.sync {
      numberOfActiveRequests -= 1
    }
  }
}
