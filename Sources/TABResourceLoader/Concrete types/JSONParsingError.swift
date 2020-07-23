//
//  JSONParsingError.swift
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

/// Error for representing a failure while parsing JSON
///
/// - invalidJSONData: The JSON data is invalid
/// - notAJSONDictionary: The JSON provided is not a dictionary
/// - notAJSONArray: The JSON provided is not an array
/// - cannotParseJSONDictionary: Failed to create a Model from the JSON dictionary
/// - cannotParseJSONArray: Failed to create a Model from the JSON array
enum JSONParsingError: Error {
  case invalidJSONData
  case notAJSONDictionary
  case notAJSONArray
  case cannotParseJSONDictionary
  case cannotParseJSONArray
}
