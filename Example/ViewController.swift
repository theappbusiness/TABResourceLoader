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
    fetchMultipleResponseExample()
    failureModelExample()
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

  func fetchMultipleResponseExample() {
    let americaResource = MultipleResponseResource(continent: "america")

    generalService.fetch(resource: americaResource) { networkResponse in
      print(networkResponse)
    }

    let europeResource = MultipleResponseResource(continent: "europe")

    generalService.fetch(resource: europeResource) { networkResponse in
      print(networkResponse)
    }

    let singleCityResource = MultipleResponseResource(continent: "single_city")

    generalService.fetch(resource: singleCityResource) { networkResponse in
      print(networkResponse)
    }
  }

  func fetchDecodable() {
    let productsResource = ProductsResource()

    generalService.fetch(resource: productsResource) { networkResponse in
      print(networkResponse)
    }

    let nestedResponseResource = ProductNestedInResponseResource()

    generalService.fetch(resource: nestedResponseResource) { networkResponse in
      print(networkResponse)
    }

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

  private func failureModelExample() {
    let resource = RegistrationResource(emailAddress: "not an email")
    generalService.fetch(resource: resource) { [weak self] (result) in

      switch result {
      case .success(let successResult, _):
        self?.handleRegistrationResult(successResult)
      case .failure(let error, _):
        print(error)
      }
    }
  }

  private func handleRegistrationResult(_ result: RegistrationResult) {
    switch result {
    case .success(let id):
      print(id)
    case .failure(let registrationError):
      print(registrationError.description)
    }
  }

}
