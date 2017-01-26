# Responding to network activity

To listen to changes on the network activity a closure can be set, for example:

```swift
NetworkServiceActivity.activityChangeHandler = { isActive in
  application.isNetworkActivityIndicatorVisible = isActive
}
```

It is recommended that this is setup on application launch, for example:

```swift
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
      application.isNetworkActivityIndicatorVisible = isActive
    }
  }
  
}
```