# Change Log

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
