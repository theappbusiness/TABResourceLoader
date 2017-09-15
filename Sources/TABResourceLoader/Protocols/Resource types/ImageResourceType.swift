//
//  ImageResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Luciano Marisi
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

import UIKit

public enum ImageDownloadingError: Error {
  case invalidImageData
}

/**
 *  Defines a specific ResourceType for Image resources
 */
public protocol ImageResourceType: DataResourceType where Model: UIImage {

  /**
   Takes NSData and returns a result which is either Success with an Image or Failure with an error

   - parameter data: Input Image Data

   - returns: Result of image decoding.
   */
  func model(from data: Data) throws -> Model
}

// MARK: - Convenince parsing functions
extension ImageResourceType {

  public func model(from data: Data) throws -> UIImage {
    guard let image = UIImage(data: data) else {
      throw ImageDownloadingError.invalidImageData
    }
    return image
  }

}
