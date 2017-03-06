# Using failure model example

In some cases your request might return a server error (i.e. 4xx or 5xx), but you may still want to parse the data into a failure model.

For example, the server returns response code 400, with JSON body:

```json
{
  "errorCode": "incorrectPassword"
}
```

TAB resource loader will still return a `NetworkResponse` enum with a `.failure` case for this request but it may still contain the required model.

### Defining the failure model

In our resource, we can set the model to be some sort of result that tells us if it contains the successful model data or failure model data.

```swift
enum RegistrationResult {
  case success(id: Int)
  case failure(type: RegistrationErrorType)
}

struct RegistrationResource: NetworkJSONDictionaryResourceType {
  typealias Model = RegistrationResult
}

```

Where `RegistrationErrorType` contains all the relevant errors we may need to use in our app:

```swift
enum RegistrationErrorType {
  case invalidEmailFormat
  case invalidPasswordFormat

  init(error: String) throws {
    switch error {
    case "incorrectPassword":
      self = .invalidPasswordFormat
    case "incorrectEmail":
      self = .invalidEmailFormat
    default: throw RegistrationParsingError()
    }
  }

}

```

When parsing, we can check the data for errors, in our case for `"errorCode"`:
```swift
func model(from jsonDictionary: [String : Any]) throws -> Model {
  if let error = jsonDictionary["errorCode"] as? String {
    let error = try RegistrationErrorType(error: error)
    return .failure(type: error)
  }

  return .success(id: 123)
}
```

### Making the request

When handling the request, we can get the failure model even if the request returns a failure case:

```swift
private func failureModelExample() {
  let resource = RegistrationResource(emailAddress: "not an email")
  generalService.fetch(resource: resource) { [weak self] (result) in

    switch result {
    case .success(let successResult, _):
      self?.handleRegistgrationResult(successResult)
    case .failure(let reistrationResult, _, let error):
      if case let .success(errorResult) = registrationResult {
        self?.handleRegistrationResult(errorResult)
      } else {
        print(error)
      }
    }
  }
}

private func handleRegistrationResult(_ result: RegistrationResult) {
  // Handle registration result enum
}
```
