# Change Log

## 7.0.1

- Removed superfluous SwiftLint disablement.

## 7.0.0

- Handle failure to parse model in a dedicated failure case. If the response is successful, but an error is thrown during parsing, then a `NetworkServiceError.parsingModel` failure case is passed along to the completion.

## 6.1.0

- Added Codable support (`JSONDecodableResourceType`, et al)

## 6.0.0

- Migrated to Swift 4


## 5.0.1

- Moved internal `Result` to test target

## 5.0.0

- The error from a failed `NetworkResponse` is now flattened and moved into the `NetworkServiceError` `couldNotParseModel` case to avoid nested switch statements: 

```swift
enum NetworkResponse<Model> {
  case success(Model, HTTPURLResponse)
  case failure(NetworkServiceError, HTTPURLResponse?)
}
```

## 4.0.0

- `DataResourceType` transformation function now throws on failure instead of returning `Result<Model>`:

	```swift
	// Old interface
	func result(from data: Data) -> Result<Model>
	// New interface
	func model(from data: Data) throws -> Model
	```
	
- `JSONDictionaryResourceType` transformation function now throws on failure instead of returning `Model?`:

	```swift
	// Old interface
	func model(from jsonDictionary: [String : Any]) -> Model?
	// New interface
	func model(from jsonDictionary: [String : Any]) throws -> Model
	```

- `JSONArrayResourceType` transformation function now throws on failure instead of returning `Model?`:

	```swift
	// Old interface
	func model(from jsonArray: [Any]) -> Model?
	// New interface
	func model(from jsonArray: [Any]) throws -> Model
	```
	
- Refactored network service
	- Renamed `NetworkDataResourceService` to `GenericNetworkDataResourceService`, this is useful when using it with `ResourceOperation`
	- New `NetworkDataResourceService` uses a generic fetching function
	- `NetworkDataResourceService` now uses `NetworkResponse` as the result type in the completion handler

## 3.2.0

- Issue #21 - Added support for cancelling request
	- `NetworkDataResourceService` now returns a `Cancellable` type

## 3.1.1

- Removed unnecessary `ResourceOperationType` protocol
- `NetworkDataResourceService` now invalidates it's session on deinit

## 3.1.0

- Added support for listen to network activity changes, useful for setting up `isNetworkActivityIndicatorVisible` on `UIApplication`
- `fetch(resource: Resource, completion: @escaping (Result<Resource.Model>) -> Void)` method on `NetworkDataResourceService` is now `open` for overriding

## 3.0.3

- Added documentation on `BaseAsynchronousOperation`
- Removed errors parameter from `finish()` in `BaseAsynchronousOperation`

## 3.0.2

- `URLSession` used by `NetworkDataResourceService` is now exposed in the initializer

## 3.0.1

- `resource`, `service` and `didFinishFetchingResourceCallback` properties in `ResourceOperation` are now `internal` to allow for unit testing purposes

## 3.0.0

- Removed deprecated `JSONResourceType` and `NetworkJSONResourceType`
- Issue #9 - Improvements to meet Swift API guidelines

## 2.1.0

### Bug fixes

- Issue #3 - Query items on the `URL` for a `NetworkResourceType` are now added to the generated `URLRequest`

### New features

- Issue #4 - Introduced `JSONArrayResourceType` and `JSONDictionaryResourceType` in favour of now deprecated `JSONResourceType`
- Issue #7 - `HTTPMethod` now uses lower case enums, e.g. `get` instead of `GET`

## 2.0.0

- Migrated to Swift 3

## 1.0.0

- Initial release
- Retrieve JSON or image resources using a network service
- Included a resource operation to manage concurrency
