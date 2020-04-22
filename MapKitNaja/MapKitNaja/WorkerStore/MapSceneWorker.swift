//
//  MapSceneWorker.swift
//  MapKitNaja
//
//  Created by CHAIWAT CHANTHASEN on 22/4/2563 BE.
//  Copyright (c) 2563 CHAIWAT CHANTHASEN. All rights reserved.
//

import UIKit

protocol MapSceneStoreProtocol {
  func getGeoCoderLocation(request: GeoLocation.Request, completion: @escaping (UserResult<GeoLocation.Response>) -> Void)
}

class MapSceneWorker {

  var store: MapSceneStoreProtocol

  init(store: MapSceneStoreProtocol) {
    self.store = store
  }

  // MARK: - Business Logic
  func getGeoLocationDetail(request: GeoLocation.Request, completion: @escaping (UserResult<GeoLocation.Response>) -> Void) {
    store.getGeoCoderLocation(request: request, completion: completion)
  }
}
