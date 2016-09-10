//
//  ImageResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public enum ImageDownloadingError: ErrorType {
  case InvalidImageData
}

/**
 *  Defines a specific ResourceType for Image resources
 */
public protocol ImageResourceType: DataTransformableResourceType {
  
  associatedtype Model: UIImage
  
  /**
   Takes NSData and returns a result which is either Success with an Image or Failure with an error
   
   - parameter data: Input Image Data
   
   - returns: Result of image decoding.
   */
  func resultFrom(data data: NSData) -> Result<Model>
}

// MARK: - Convenince parsing functions
extension ImageResourceType {
  public func resultFrom(data data: NSData) -> Result<UIImage> {
    guard let image = UIImage(data: data) else {
      return Result.Failure(ImageDownloadingError.InvalidImageData)
    }
    return .Success(image)
  }
}