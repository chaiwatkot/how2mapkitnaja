//
//  MapSceneWorker.swift
//  MapKitNaja
//
//  Created by CHAIWAT CHANTHASEN on 22/4/2563 BE.
//  Copyright (c) 2563 CHAIWAT CHANTHASEN. All rights reserved.
//

import UIKit

protocol MapSceneStoreProtocol {
  func getData(_ completion: @escaping (Result<Entity>) -> Void)
}

class MapSceneWorker {

  var store: MapSceneStoreProtocol

  init(store: MapSceneStoreProtocol) {
    self.store = store
  }

  // MARK: - Business Logic

  func doSomeWork(_ completion: @escaping (Result<Entity>) -> Void) {
    // NOTE: Do the work
    store.getData {
      // The worker may perform some small business logic before returning the result to the Interactor
      completion($0)
    }
  }
}
