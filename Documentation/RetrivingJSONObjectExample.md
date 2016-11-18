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
  init?(jsonDictionary: [String : AnyObject]) {
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
private let baseURL = NSURL(string: "http://localhost:8000/")!
```

```swift
struct CitiesResource: NetworkJSONDictionaryResourceType {
  typealias Model = [City]
  
  let url: NSURL
  
  init(continent: String) {
    url = baseURL.URLByAppendingPathComponent("\(continent).json")
  }
  
  //MARK: JSONResource
  func modelFrom(jsonDictionary jsonDictionary: [String: AnyObject]) -> [City]? {
    guard let
      citiesJSONArray = jsonDictionary["cities"] as? [[String: AnyObject]]
      else {
        return nil // OR []
    }
    return citiesJSONArray.flatMap(City.init)
  }
  
}
```

### Retrieving the resource

Use the provided `NetworkDataResourceService` to retrieve your `CitiesResource` from a web service:

```swift
let europeResource = CitiesResource(continent: "europe")
let networkJSONService = NetworkDataResourceService<CitiesResource>()
networkJSONService.fetch(resource: europeResource) { [weak self] result in
  // do something with the result
}
```

**OR**

Define a `typealias` for conveniency if you using `NSOperation`s:

```swift
private typealias CitiesNetworkResourceOperation = ResourceOperation<NetworkDataResourceService<CitiesResource>>
```

Create the operation using a `CitiesResource`

```swift
let europeResource = CitiesResource(continent: "europe")
let citiesNetworkResourceOperation = CitiesNetworkResourceOperation(resource: europeResource) { [weak self] operation, result in
  // do something with the result
}
```

Add the operation to some queue
```swift
let operationQueue = NSOperationQueue()
operationQueue.addOperation(citiesNetworkResourceOperation)
```
