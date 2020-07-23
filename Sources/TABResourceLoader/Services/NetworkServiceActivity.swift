//
//  NetworkServiceActivity.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 26/01/2017.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Kin + Carta
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
      DispatchQueue.main.async {
        NetworkServiceActivity.activityChangeHandler?(hasOutstandingRequests)
      }
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
