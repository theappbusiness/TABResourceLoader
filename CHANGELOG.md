# Change Log

## 4.0.0

- Made the response data available when a `statusCodeError` occurs

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
