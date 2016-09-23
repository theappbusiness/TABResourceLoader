//
//  ViewController.swift
//  Example
//
//  Created by Luciano Marisi on 17/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import UIKit
import TABResourceLoader

class ViewController: UIViewController {

  private let operationQueue = OperationQueue()
  private let service = NetworkDataResourceService<CitiesResource>()

  override func viewDidLoad() {
    super.viewDidLoad()

    let americaResource = CitiesResource(continent: "america")
    service.fetch(resource: americaResource) { (result) in
      print(result)
    }

    let resourceOperation = ResourceOperation<NetworkDataResourceService<CitiesResource>>(resource: americaResource) { operation, result in
      print(result)
    }
    operationQueue.addOperation(resourceOperation)

  }

}

