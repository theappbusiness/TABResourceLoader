# Using TABResourceLoader with Decodable objects

In the following examples, we use a Swift struct representation of a City, conforming to the `Decodable` protocol introduced in Swift 4.

```swift
struct City: Decodable {
  let name: String
  let latitude: Double
  let longitude: Double
}
```

## Example 1: Object appears at root of JSON response

Let's say the web service returns a JSON representation of a city as follows:

```json
{
  "name": "Paris",
  "latitude": 48.8566,
  "longitude": 2.3522
}
```

A `SingleCityResource` object defines where the city data will come from and how the base endpoint should be parsed.

In this simplest of examples, the root of the response contains the city object, so our `CityResource` would be as follows:

```swift
struct SingleCityResource: NetworkJSONDecodableResourceType {
  typealias Model = City
  typealias Root = Model

  let url = URL(string: "http://localhost:8000/cities/paris")!
}
```

## Example 2: Object of interest appears nested within other JSON

Let's say the web service returns a JSON representation of a city as follows:

```json
{
  "data": {
    "city": {
      "name": "Paris",
      "latitude": 48.8566,
      "longitude": 2.3522
    }
  }
}
```

In this example, our `SingleCityResource` defines the nesting structure of the response:

```swift
struct SingleCityResource: NetworkJSONDecodableResourceType {
  typealias Model = City

  let url = URL(string: "http://localhost:8000/cities/paris")!

  struct ResponseData: Decodable {
    let data: NestedData
    struct NestedData: Decodable {
      let city: Product
    }
  }

  func model(mappedFrom root: ResponseData) throws -> City {
    return root.data.city
  }
}
```

Note that the `associatedtype Root` is inferred from the argument of our `model(mappedFrom:)` implementation.

## Example 3: Array of objects

Let's say the server returns an array

```json
[
  {
    "name": "Paris",
    "latitude": 48.8566,
    "longitude": 2.3522
  },
  {
    "name": "London",
    "latitude": 51.5074,
    "longitude": 0.1278
  }
]
```

Because an array of `Decodable` objects conforms to `Decodable`, we just need to declare that as our associated type. So a `CitiesResource` would look like so:

```swift
struct CitiesResource: NetworkJSONDecodableResourceType {
  typealias Model = [City]
  typealias Root = Model
  
  let url = URL
  
  init(continent: String) {
    url = URL(string: "http://localhost:8000/cities/\(continent)")!
  }
}
```

This works the same whether the array comes at the root of the response or nested. See the nesting example above.


# Retrieving the resource

Use the provided `NetworkDataResourceService` to retrieve your `SingleCityResource` or `CitiesResource` from a web service. For example:

```swift
// declared somewhere that will remain in scope, e.g. at instance level
let networkService = NetworkDataResourceService()

// later, when needing to access the network
let europeResource = CitiesResource(continent: "europe")
networkService.fetch(resource: europeResource) { networkResponse in
  // handle repsonse, e.g.
  // switch networkResponse { case let .success(cities, _): // do something with cities
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

Add the operation to some queue:

```swift
let operationQueue = OperationQueue()
operationQueue.addOperation(citiesNetworkResourceOperation)
```
