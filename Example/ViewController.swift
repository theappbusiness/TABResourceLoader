//
//  ViewController.swift
//  Example
//
//  Created by Luciano Marisi on 17/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import UIKit
import TABResourceLoader

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

    generalService.fetch(resource: americaResource) { networkResponse in
      print(networkResponse)
    }

    let citiesResourceOperation = CitiesResourceOperation(resource: americaResource) { _, networkResponse in
      print(networkResponse)
    }
    operationQueue.addOperation(citiesResourceOperation)
  }

  func fetchImageExample() {
    let largeImageURL = URL(string: "https://static.pexels.com/photos/4164/landscape-mountains-nature-mountain.jpeg")!
    let imageResource = NetworkImageResource(url: largeImageURL)

    imageService.fetch(resource: imageResource) { networkResponse in
      print(networkResponse)
    }

    let imageOperation = NetworkImageResourceOperation(resource: imageResource) { [weak self] _, networkResponse in
      if case let .success(image, _) = networkResponse {
        self?.imageView.image = image
      }
    }
    operationQueue.addOperation(imageOperation)
  }

}
