# Retriving an image from a web service example

The library comes with a concrete type, `NetworkImageResource`, which represents a simple image resource.

To retrive an image, first create and `NetworkImageResource` with the relevant `URL`: 

```swift
let imageURL = URL(string: "http://www.theappbusiness.com/apple-touch-icon-180x180.png")!
let imageResource = NetworkImageResource(url: imageURL)
```

**Either**

Use a `NetworkDataResourceService` directly:

```swift
let imageService = NetworkDataResourceService<NetworkImageResource>()
```

```swift
imageService.fetch(resource: imageResource) { (result) in
  if case let .success(image) = result {
    // Do something with the image. If using UIKit remember to dispatch to the main thread.
  }
}
```

**OR**

Use a `ResourceOperation` with `NetworkDataResourceService`:

```swift
let operationQueue = OperationQueue()
```

```swift
let imageOperation = ResourceOperation<NetworkDataResourceService<NetworkImageResource>>(resource: imageResource) { [weak self] _, result in
  if case let .success(image) = result {
    // Do something with the image. If using UIKit remember to dispatch to the main thread.
  }
}
operationQueue.addOperation(imageOperation)
```
