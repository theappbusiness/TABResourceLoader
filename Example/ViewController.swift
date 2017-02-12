//
//  ViewController.swift
//  Example
//
//  Created by Luciano Marisi on 17/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import UIKit
import TABResourceLoader

class Subclass: NetworkDataResourceService {

  override init(session: URLSessionType) {
    super.init(session: session)
  }

  override func fetch<Resource: DataResourceType & NetworkResourceType>(resource: Resource, completion: @escaping (Result<Resource.Model>) -> Void) -> Cancellable? {
    return super.fetch(resource: resource, completion: completion)
  }
}

private typealias CitiesResourceOperation = ResourceOperation<GenericNetworkDataResourceService<CitiesResource>>
private typealias NetworkImageResourceOperation = ResourceOperation<GenericNetworkDataResourceService<NetworkImageResource>>

class ViewController: UIViewController {

  @IBOutlet private var imageView: UIImageView!

  private let operationQueue = OperationQueue()
  private let generalService = NetworkDataResourceService()
  private let citiesService = GenericNetworkDataResourceService<CitiesResource>()
  private let imageService = GenericNetworkDataResourceService<NetworkImageResource>()

  override func viewDidLoad() {
    super.viewDidLoad()
    fetchJSONExample()
    fetchImageExample()
  }

  func fetchJSONExample() {
    let americaResource = CitiesResource(continent: "america")
    citiesService.fetch(resource: americaResource) { (result) in
      print(result)
    }

    generalService.fetch(resource: americaResource) { result in
      print(result)
    }

    let citiesResourceOperation = CitiesResourceOperation(resource: americaResource) { _, result in
      print(result)
    }
    operationQueue.addOperation(citiesResourceOperation)
  }

  func fetchImageExample() {
    let largeImageURL = URL(string: "https://static.pexels.com/photos/4164/landscape-mountains-nature-mountain.jpeg")!
    let imageResource = NetworkImageResource(url: largeImageURL)

    imageService.fetch(resource: imageResource) { (_) in
      // Do something with result
    }

    let imageOperation = NetworkImageResourceOperation(resource: imageResource) { [weak self] _, result in
      if case let .success(image) = result {
        self?.imageView.image = image
      }
    }
    operationQueue.addOperation(imageOperation)
  }

}
