//
//  MapSceneStore.swift
//  MapKitNaja
//
//  Created by CHAIWAT CHANTHASEN on 22/4/2563 BE.
//  Copyright (c) 2563 CHAIWAT CHANTHASEN. All rights reserved.
//

import Foundation
import CoreLocation

class MapSceneStore: MapSceneStoreProtocol {
  func getGeoCoderLocation(request: GeoLocation.Request, completion: @escaping (UserResult<GeoLocation.Response>) -> Void) {
    let geoCoder = CLGeocoder()
    geoCoder.reverseGeocodeLocation(request.location) { (placeMarks, error) in
      if let placeMarkList = placeMarks {
        completion(UserResult.success(result: GeoLocation.Response(locationDetails: placeMarkList)))
      } else if let errorja = error {
        completion(UserResult.failure(error: errorja))
      }
    }
  }
}
