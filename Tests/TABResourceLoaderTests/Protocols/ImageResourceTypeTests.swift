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

  struct MockImageResourceType: ImageResourceType {
    typealias Model = UIImage
  }
  var mockImageResourceType: MockImageResourceType!

  override func setUp() {
    super.setUp()
    mockImageResourceType = MockImageResourceType()
  }

  func test_resultFromData_whenDataIsInvalid() {
    do {
      _ = try mockImageResourceType.model(from: Data())
      XCTFail("Expected .Failure but got .Success")
    } catch {
      XCTAssertEqual(error as? ImageDownloadingError, ImageDownloadingError.invalidImageData)
    }

  }

  func test_resultFromData_whenDataIsValid() {
    let mockImage = ImageMocker.mock()
    let imageData = UIImagePNGRepresentation(mockImage)!
    let testResult = try? mockImageResourceType.model(from: imageData)
    XCTAssertNotNil(testResult)
  }

}
