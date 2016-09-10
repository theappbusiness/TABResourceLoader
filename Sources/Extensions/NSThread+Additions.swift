//
//  NSThread+Additions.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

extension Thread {
  /**
   Checks the current thread and runs the given closure synchronously on the main thread.
   
   - parameter mainThreadClosure: the closure to call on the main thread
   */
  static func rl_executeOnMain(_ mainThreadClosure: () -> Void) {
    if self.current == self.main {
      mainThreadClosure()
    } else {
      
      let queue = DispatchQueue.main
      queue.sync(execute: {
        mainThreadClosure()
      })
      
    }
  }
  
}
