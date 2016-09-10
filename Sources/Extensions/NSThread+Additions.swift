//
//  NSThread+Additions.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

extension NSThread {
  /**
   Checks the current thread and runs the given closure synchronously on the main thread.
   
   - parameter mainThreadClosure: the closure to call on the main thread
   */
  static func rl_executeOnMain(mainThreadClosure: () -> Void) {
    if self.currentThread() == self.mainThread() {
      mainThreadClosure()
    } else {
      
      let queue = dispatch_get_main_queue()
      dispatch_sync(queue, {
        mainThreadClosure()
      })
      
    }
  }
  
}
