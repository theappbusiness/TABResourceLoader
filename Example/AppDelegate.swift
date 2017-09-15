//
//  AppDelegate.swift
//  Example
//
//  Created by Luciano Marisi on 17/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import UIKit
import TABResourceLoader

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    setupNetworkActivityHandler(for: application)
    return true
  }

  private func setupNetworkActivityHandler(for application: UIApplication) {
    NetworkServiceActivity.activityChangeHandler = { isActive in
      DispatchQueue.main.async {
        application.isNetworkActivityIndicatorVisible = isActive
      }
    }
  }

}
