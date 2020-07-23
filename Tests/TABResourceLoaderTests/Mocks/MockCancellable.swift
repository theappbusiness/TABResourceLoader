//
//  MockCancellable.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 13/02/2017.
//  Copyright © 2017 Kin + Carta. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

class MockCancellable: Cancellable {
  var cancelCallCount = 0
  func cancel() {
    cancelCallCount += 1
  }
}
