//
//  ImageResourceTypeTests.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import TABResourceLoader

class ImageResourceTypeTests: XCTestCase {

  struct MockImageResourceType: ImageResourceType {}
  var mockImageResourceType: MockImageResourceType!

  override func setUp() {
    super.setUp()
    mockImageResourceType = MockImageResourceType()
  }

  func test_resultFromData_whenDataIsInvalid() {
    let testResult = mockImageResourceType.result(from: Data())
    guard case .failure(let error) = testResult else {
      XCTFail("Expected .Failure but got .Success")
      return
    }
    switch error {
    case ImageDownloadingError.invalidImageData:
      return
    default:
      XCTFail("Expected ImageDownloadingError.InvalidImageData but got \(type(of: error))")
    }
  }

  func test_resultFromData_whenDataIsValid() {
    let mockImage = ImageMocker.mock()
    let imageData = UIImagePNGRepresentation(mockImage)!
    let testResult = mockImageResourceType.result(from: imageData)
    guard case .success = testResult else {
      XCTFail("Expected .Success but got .Failure")
      return
    }
  }

}
