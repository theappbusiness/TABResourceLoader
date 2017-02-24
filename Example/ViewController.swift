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
    failureModelExample()
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
      if case let .success(image, _) = result {
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
      case .failure(let registrationResult, _, let error):
        if case let .success(errorResult) = registrationResult {
          self?.handleRegistrationResult(errorResult)
        } else {
          print(error)
        }
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
