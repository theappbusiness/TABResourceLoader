//
//  BaseAsynchronousOperation.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
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

/// Base class for setting up KVO boilerplate code of an Operation
open class BaseAsynchronousOperation: Operation {

  open override var isAsynchronous: Bool {
    return true
  }

  fileprivate var _executing: Bool = false
  open override var isExecuting: Bool {
    get { return _executing }
    set {
      willChangeValue(forKey: "isExecuting")
      _executing = newValue
      didChangeValue(forKey: "isExecuting")
      if _cancelled == true {
        self.isFinished = true
      }
    }
  }
  fileprivate var _finished: Bool = false
  open override var isFinished: Bool {
    get { return _finished }
    set {
      willChangeValue(forKey: "isFinished")
      _finished = newValue
      didChangeValue(forKey: "isFinished")
    }
  }

  fileprivate var _cancelled: Bool = false
  open override var isCancelled: Bool {
    get { return _cancelled }
    set {
      willChangeValue(forKey: "isCancelled")
      _cancelled = newValue
      didChangeValue(forKey: "isCancelled")
    }
  }

  public final override func start() {
    self.isExecuting = true
    main()
  }

  public final override func main() {
    if isCancelled {
      isExecuting = false
      isFinished = true
      return
    }
    execute()
  }

  /// Method to be overridden with the implementation of the work done on the operation
   open func execute() {
    assertionFailure("execute must overriden")
    finish()
  }

  /// Call this method after all the work is done to signal the completion of this operation
  public final func finish() {
    self.isFinished = true
    self.isExecuting = false
  }

  open override func cancel() {
    super.cancel()
    isCancelled = true
    if isExecuting {
      isExecuting = false
      isFinished = true
    }
  }
}
