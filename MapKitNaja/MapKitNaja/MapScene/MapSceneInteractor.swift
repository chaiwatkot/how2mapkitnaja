//
//  MapSceneInteractor.swift
//  MapKitNaja
//
//  Created by CHAIWAT CHANTHASEN on 22/4/2563 BE.
//  Copyright (c) 2563 CHAIWAT CHANTHASEN. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapSceneInteractorInterface {
  func getTappedCoordinate(request: MapScene.GetTappedCoordinate.Request)
  func getLocationDetails(request: MapScene.GetLocationDetails.Request)
  func getAnnpotation(request: MapScene.GetAnnotation.Request)
  func updateRegion(request: MapScene.UpdateRegion.Request)
  func getCurrentLocationFromMap(request: MapScene.GetCurrentLocationFromMap.Request)
}

final class MapSceneInteractor: MapSceneInteractorInterface {
  var presenter: MapScenePresenterInterface!
  var worker: MapSceneWorker?
  
  // set default to 3 km.
  var regionMeters: Double = 3000
  var currentLocation: CLLocation?

  // MARK: - Business logic
  func getTappedCoordinate(request: MapScene.GetTappedCoordinate.Request) {
    let response = MapScene.GetTappedCoordinate.Response(cgPoint: request.cgPoint, map: request.map)
    presenter.presentTappedCoordinate(response: response)
  }
  
  func getLocationDetails(request: MapScene.GetLocationDetails.Request) {
    let latitude = request.coordinate.latitude
    let longitude = request.coordinate.longitude
    let location = CLLocation(latitude: latitude, longitude: longitude)
    
    worker?.getGeoLocationDetail(request: GeoLocation.Request(location: location), completion: { [weak self] result in
      switch result {
      case .success(result: let result):
        let response = MapScene.GetLocationDetails.Response(locationDetails: .success(result: result))
        self?.presenter.presentGetLocationDetails(response: response)
      case .failure(error: let userError):
        let response = MapScene.GetLocationDetails.Response(locationDetails: .failure(error: userError))
        self?.presenter.presentGetLocationDetails(response: response)
      }
    })
  }

  func getAnnpotation(request: MapScene.GetAnnotation.Request) {
    let response = MapScene.GetAnnotation.Response(coordinate: request.coordinate)
    presenter.presentAnnotation(response: response)
  }
  
  func updateRegion(request: MapScene.UpdateRegion.Request) {
    let response = MapScene.UpdateRegion.Response(coordinate: request.coordinate, regionMeter: regionMeters)
    presenter.presentUpdateRegion(response: response)
  }
  
  func getCurrentLocationFromMap(request: MapScene.GetCurrentLocationFromMap.Request) {
    let latitude = request.coordinate.latitude
    let longitude = request.coordinate.longitude
    var location = CLLocation(latitude: latitude, longitude: longitude)
    if let currentLocation = self.currentLocation {
      location = currentLocation
    }
        
    let response = MapScene.GetCurrentLocationFromMap.Response(location: location)
    presenter.presentGetCurrentLocation(response: response)
  }
}
