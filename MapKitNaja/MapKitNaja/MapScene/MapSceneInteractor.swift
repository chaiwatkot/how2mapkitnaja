//
//  MapSceneInteractor.swift
//  MapKitNaja
//
//  Created by CHAIWAT CHANTHASEN on 22/4/2563 BE.
//  Copyright (c) 2563 CHAIWAT CHANTHASEN. All rights reserved.
//

import UIKit

protocol MapSceneInteractorInterface {
  func doSomething(request: MapScene.Something.Request)
  var model: Entity? { get }
}

class MapSceneInteractor: MapSceneInteractorInterface {
  var presenter: MapScenePresenterInterface!
  var worker: MapSceneWorker?
  var model: Entity?

  // MARK: - Business logic

  func doSomething(request: MapScene.Something.Request) {
    worker?.doSomeWork { [weak self] in
      if case let Result.success(data) = $0 {
        // If the result was successful, we keep the data so that we can deliver it to another view controller through the router.
        self?.model = data
      }

      // NOTE: Pass the result to the Presenter. This is done by creating a response model with the result from the worker. The response could contain a type like UserResult enum (as declared in the SCB Easy project) with the result as an associated value.
      let response = MapScene.Something.Response()
      self?.presenter.presentSomething(response: response)
    }
  }
}
