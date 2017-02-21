# Retriving a JSON object example

Let's say you need to retrieve this JSON from an server, `http://localhost:8000/<continent>.json`:

```json
{
  "cities": [{
    "name": "Paris"
  }, {
    "name": "London"
  }]
}
```

The Swift model for a city could look something like this:

```swift
struct City {
  let name: String
}
```

Some basic parsing logic:

```swift
extension City {
  init?(jsonDictionary: [String : Any]) {
    guard let parsedName = jsonDictionary["name"] as? String else {
      return nil
    }
    name = parsedName
  }
}
```

### Defining a `Resource`

A `CitiesResource` can be created to define where the cities will come from and how the base endpoint should be parsed:

```swift
private let baseURL = URL(string: "http://localhost:8000/")!
```

```swift
enum CitiesResourceError: Error {
  case parsingFailed
}

struct CitiesResource: NetworkJSONDictionaryResourceType {
  typealias Model = [City]

  let url: URL

  init(continent: String) {
    url = baseURL.appendingPathComponent("\(continent).json")
  }

  // MARK: JSONDictionaryResourceType
  func model(from jsonDictionary: [String : Any]) throws -> Model {
    guard let
      citiesJSONArray = jsonDictionary["cities"] as? [[String: Any]]
      else {
        throw CitiesResourceError.parsingFailed
    }
    return citiesJSONArray.flatMap(City.init)
  }

}
```

### Retrieving the resource

Use the provided `NetworkDataResourceService` to retrieve your `CitiesResource` from a web service:

```swift
let europeResource = CitiesResource(continent: "europe")
let networkService = NetworkDataResourceService()
networkService.fetch(resource: europeResource) { networkResponse in
  // do something with the networkResponse
}
```

**OR**

Define a `typealias` for conveniency if you using `(NS)Operation`s:

```swift
private typealias CitiesNetworkResourceOperation = ResourceOperation<GenericNetworkDataResourceService<CitiesResource>>
```

Create the operation using a `CitiesResource`

```swift
let europeResource = CitiesResource(continent: "europe")
let citiesNetworkResourceOperation = CitiesNetworkResourceOperation(resource: europeResource) { operation, networkResponse in
  // do something with the networkResponse
}
```

Add the operation to some queue
```swift
let operationQueue = OperationQueue()
operationQueue.addOperation(citiesNetworkResourceOperation)
```
