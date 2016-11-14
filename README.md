# TABResourceLoader

[![Build Status](https://travis-ci.org/theappbusiness/TABResourceLoader.svg?branch=master)](https://travis-ci.org/theappbusiness/TABResourceLoader)
[![](https://img.shields.io/cocoapods/v/TABResourceLoader.svg)](https://cocoapods.org/pods/TABResourceLoader)
[![](https://img.shields.io/cocoapods/p/TABResourceLoader.svg?style=flat)](https://cocoapods.org/pods/TABResourceLoader)
[![codecov.io](http://codecov.io/github/theappbusiness/TABResourceLoader/coverage.svg?branch=master)](http://codecov.io/github/theappbusiness/TABResourceLoader?branch=master)

This is library is designed to fetch resources in a consistent and modular way. The user can define resources by conforming to protocols that define where and how to get them. These resources can then be retrieved using a generic service type with or without an operation provided by the library. By following this approach it's easy to have testable and modular networking stack.

## Example use cases

- [Retriving a JSON object](Documentation/RetrivingJSONObjectExample.md)
- [Retriving an image](Documentation/RetrivingImageExample.md)

## Main concepts

This library defines/uses 3 concepts: resource, service and operation

- A **Resource** represents where something is and how it can be retrieved.
	- For example a resource could define the url of where a JSON file is and how to parse into strongly types model
- A **Service** represents a type that can retrive resources, generally conforms to `ResourceServiceType`.
	- For example the library ships with a network service that is responsible for fetching a network resource
- A **ResourceOperation** can used to manage concurrency and dependencies as services can be defined not to be asynchrnous, generally conforms `ResourceOperationType`.

### Available Resource protocols

#### Root protocols

- `ResourceType`
	- Base type for mapping a resource to a generic `Model` type
- `NetworkResourceType`
	- Defines how a resource could be retrieved using a network service. As a bare minimum a `URL` needs to be defined, all other properties (e.g. HTTP method have defaults).

#### Conforming to `ResourceType`

- `DataResourceType`
	- Resource for retriving a `Model` from `Data`

#### Conforming to `DataResourceType`

- `ImageResourceType`
	- Resource for retriving a `UIImage` from `Data`
- `JSONArrayResourceType`
	- Resource for retriving a generic `Model` from JSON array `[Any]`
- `JSONDictionaryResourceType`
	- Resource for retriving a generic `Model` from JSON dictionary `[String: Any]`

#### Combined protocols

- `NetworkJSONArrayResourceType`
	- Combines `JSONArrayResourceType` and `NetworkResourceType` to allow for retrieving a generic `Model` from a JSON array. Includes default header values `["Content-Type": "application/json"]`
- `NetworkJSONDictionaryResourceType`
 	- Combines `JSONDictionaryResourceType` and `NetworkResourceType` to allow for retrieving a generic `Model` from a JSON dictionary. Includes default header values `["Content-Type": "application/json"]`

#### Concrete types

- `NetworkImageResource`

### Available service types conforming to `ResourceServiceType`

- `NetworkDataResourceService`

### Available operation types conforming to `ResourceOperationType`

- `ResourceOperation`


## Advanced configurations

### Creating your own services and operations

At the moment the only service provided is the `NetworkDataResourceService`. This may change in future updates where it could be relevant to ship this library with more default services. In the meantime the user can create their own service by conforming to `ResourceServiceType`. Similarly, even though the `ResourceOperation` may cater for most needs the developer can choose to have their own resource operation that conforms to `ResourceOperationType`.

## Author

Luciano Marisi [@lucianomarisi](http://twitter.com/lucianomarisi)

**The original idea for this pattern is explained on [Protocol oriented loading of resources from a network service in Swift](http://www.marisibrothers.com/2016/07/protocol-oriented-loading-of-resources.html)**

## License

TABResourceLoader is available under the MIT license. See the LICENSE file for more info.