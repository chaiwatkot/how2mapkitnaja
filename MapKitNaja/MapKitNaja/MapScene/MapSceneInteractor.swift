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
}

final class MapSceneInteractor: MapSceneInteractorInterface {
  var presenter: MapScenePresenterInterface!
  var worker: MapSceneWorker?
  
  // set default to 3 km.
  private var regionMeters: Double = 3000
  private var currentLocation: CLLocation?
  private var targetLocation: CLLocation?

  // MARK: - Business logic
  func getTappedCoordinate(request: MapScene.GetTappedCoordinate.Request) {
    guard let currentLocation = self.currentLocation else { return }
    let tappedCoordinate = request.map.convert(request.cgPoint, toCoordinateFrom: request.map)
    let targetLocation = CLLocation(latitude: tappedCoordinate.latitude, longitude: tappedCoordinate.longitude)
    self.targetLocation = targetLocation
    let response = MapScene.GetTappedCoordinate.Response(targetLocation: targetLocation, currentLocation: currentLocation, coordinate: tappedCoordinate)
    presenter.presentTappedCoordinate(response: response)
  }
  
  func getLocationDetails(request: MapScene.GetLocationDetails.Request) {
    let latitude = request.coordinate.latitude
    let longitude = request.coordinate.longitude
    let location = CLLocation(latitude: latitude, longitude: longitude)
    
    worker?.getGeoLocationDetail(request: GeoLocation.Request(location: location), completion: { [weak self] result in
      switch result {
      case .success(result: let result):
        let details = MapScene.GeoDetails(locationDetails: result, type: request.type)
        let response = MapScene.GetLocationDetails.Response(result: .success(result: details))
        self?.presenter.presentGetLocationDetails(response: response)
      case .failure(error: let userError):
        let response = MapScene.GetLocationDetails.Response(result: .failure(error: userError))
        self?.presenter.presentGetLocationDetails(response: response)
      }
    })
  }

  func getAnnpotation(request: MapScene.GetAnnotation.Request) {
    switch request.type {
    case .currentUser:
      guard let currentLocation = self.currentLocation else { return }
      let response = MapScene.GetAnnotation.Response(locationDetails: request.locationDetails, location: currentLocation, distance: nil, type: .currentUser)
      presenter.presentAnnotation(response: response)
    case .other:
      guard
        let currentLocation = self.currentLocation,
        let targetLocation = self.targetLocation
        else { return }
      let distance = currentLocation.distance(from: targetLocation)
      let response = MapScene.GetAnnotation.Response(locationDetails: request.locationDetails, location: targetLocation, distance: distance, type: .other)
      presenter.presentAnnotation(response: response)
    }
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
    } else {
      self.currentLocation = location
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
