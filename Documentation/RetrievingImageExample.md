# Retrieving an image from a web service example

The library comes with a concrete type, `NetworkImageResource`, which represents a simple image resource.

To retrieve an image, first create and `NetworkImageResource` with the relevant `URL`: 

```swift
let imageURL = URL(string: "http://www.theappbusiness.com/apple-touch-icon-180x180.png")!
let imageResource = NetworkImageResource(url: imageURL)
```

**Either**

Use a `NetworkDataResourceService` directly:

```swift
let networkService = NetworkDataResourceService()
```

```swift
networkService.fetch(resource: imageResource) { (result) in
  if case let .success(image, _) = result {
    // Do something with the image. If using UIKit remember to dispatch to the main thread.
  }
}
```

**OR**

Use a `ResourceOperation` with `GenericNetworkDataResourceService`:

Optionally create a typealias of NetworkImageResourceOperation

```swift
typealias NetworkImageResourceOperation = ResourceOperation<GenericNetworkDataResourceService<NetworkImageResource>>
```

```swift
let operationQueue = OperationQueue()
```

```swift
let imageOperation = NetworkImageResourceOperation(resource: imageResource) { operation, result in
  if case let .success(image, _) = result {
    // Do something with the image. If using UIKit remember to dispatch to the main thread.
  }
}
operationQueue.addOperation(imageOperation)
```
