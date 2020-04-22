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
  func getDirection(request: MapScene.GetDirection.Request)
  func getDistance(request: MapScene.GetDistance.Request)
}

final class MapSceneInteractor: MapSceneInteractorInterface {
  var presenter: MapScenePresenterInterface!
  var worker: MapSceneWorker?
  
  // set default to 3 km.
  var regionMeters: Double = 3000
  var currentLocation: CLLocation?
  var targetLocation: CLLocation?

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
  
  func getDirection(request: MapScene.GetDirection.Request) {
    let directionRequest = generateDirectionsRequest(source: request.currentLocation, target: request.tappedLocation)
    let directions = MKDirections(request: directionRequest)
    
    directions.calculate { [weak self] (result, _) in
      if let response = result {
        let response = MapScene.GetDirection.Response(dierection: .success(result: response))
        self?.presenter.presentGetDirection(response: response)
      } else {
        let response = MapScene.GetDirection.Response(dierection: .failure(error: UserError()))
        self?.presenter.presentGetDirection(response: response)
      }
    }
  }
  
  func getDistance(request: MapScene.GetDistance.Request) {
    let response = MapScene.GetDistance.Response(currentLocation: request.currentLocation, targetLocation: request.targetLocation)
    presenter.presentGetDistance(response: response)
  }
  
  //MARK: - Geberate logic
  private func generateDirectionsRequest(source: CLLocation, target: CLLocation) -> MKDirections.Request {
    let startingLocation = MKPlacemark(coordinate: source.coordinate)
    let destination = MKPlacemark(coordinate: target.coordinate)
    
    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: startingLocation)
    request.destination = MKMapItem(placemark: destination)
    request.transportType = .automobile
    request.requestsAlternateRoutes = false
    
    return request
  }
}
