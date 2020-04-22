//
//  MapScenePresenter.swift
//  MapKitNaja
//
//  Created by CHAIWAT CHANTHASEN on 22/4/2563 BE.
//  Copyright (c) 2563 CHAIWAT CHANTHASEN. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapScenePresenterInterface {
  func presentTappedCoordinate(response: MapScene.GetTappedCoordinate.Response)
  func presentGetLocationDetails(response: MapScene.GetLocationDetails.Response)
  func presentAnnotation(response: MapScene.GetAnnotation.Response)
  func presentUpdateRegion(response: MapScene.UpdateRegion.Response)
  func presentGetCurrentLocation(response: MapScene.GetCurrentLocationFromMap.Response)
  func presentGetDirection(response: MapScene.GetDirection.Response)
  func presentGetDistance(response: MapScene.GetDistance.Response)
}

final class MapScenePresenter: MapScenePresenterInterface {
  weak var viewController: MapSceneViewControllerInterface!

  // MARK: - Presentation logic
  func presentTappedCoordinate(response: MapScene.GetTappedCoordinate.Response) {
    let tappedCoordinate = response.map.convert(response.cgPoint, toCoordinateFrom: response.map)
    let location = CLLocation(latitude: tappedCoordinate.latitude, longitude: tappedCoordinate.longitude)
    
    let viewModel = MapScene.GetTappedCoordinate.ViewModel(location: location, coordinate: tappedCoordinate)
    viewController.displayTappedCoordinate(viewModel: viewModel)
  }
  
  func presentGetLocationDetails(response: MapScene.GetLocationDetails.Response) {
    switch response.locationDetails {
    case .success(result: let locationDetails):
      guard let detail = locationDetails.locationDetails?.first  else {
        presentGetLocationDetailsError()
        return
      }
      let streetNumber = detail.subThoroughfare ?? ""
      let streetName = detail.thoroughfare ?? ""
      let placeName = detail.name ?? ""
      let locationDisplay: String = "\(streetNumber), \(streetName) \n \(placeName)"
      
      let viewModel = MapScene.GetLocationDetails.ViewModel(locationDisplay: .success(result: locationDisplay))
      viewController.displayGetLocationDetails(viewModel: viewModel)
    case .failure(error: let userError):
      presentGetLocationDetailsError(userError: userError)
    }
  }

  func presentAnnotation(response: MapScene.GetAnnotation.Response) {
    let annotation = MKPointAnnotation()
    annotation.coordinate = response.coordinate
    
    let viewModel = MapScene.GetAnnotation.ViewModel(pin: annotation)
    viewController.displayAnnotationPin(viewModel: viewModel)
  }
  
  func presentUpdateRegion(response: MapScene.UpdateRegion.Response) {
    let viewModel = MapScene.UpdateRegion.ViewModel(coordinate: response.coordinate, regionMeter: response.regionMeter)
    viewController.displayUpdateRegion(viewModel: viewModel)
  }
  
  func presentGetCurrentLocation(response: MapScene.GetCurrentLocationFromMap.Response) {
    let viewModel = MapScene.GetCurrentLocationFromMap.ViewModel(location: response.location)
    viewController.displayGetCurrentLocationFromMap(viewModel: viewModel)
  }
  
  func presentGetDirection(response: MapScene.GetDirection.Response) {
    switch response.dierection {
    case .success(result: let result):
      let viewModel = MapScene.GetDirection.ViewModel(dierection: .success(result: result))
      viewController.displayGetDirection(viewModel: viewModel)
    case .failure(error: let userError):
      let viewModel = MapScene.GetDirection.ViewModel(dierection: .failure(error: userError))
      viewController.displayGetDirection(viewModel: viewModel)
    }
  }
  
  func presentGetDistance(response: MapScene.GetDistance.Response) {
    let distanceBetween = response.currentLocation.distance(from: response.targetLocation)
    let distance = String(format: "%.2f", distanceBetween / 1000 )
    
    let viewModel = MapScene.GetDistance.ViewModel(title: "Distance is \(distance) km.", description: "pai pai p'aiiiii", buttonTitle: ErrorMessageSame.okJa)
    viewController.displayGetDistance(viewModel: viewModel)
  }

  // MARK: - private func
  private func presentGetLocationDetailsError(userError: UserError = UserError()) {
    let viewModel = MapScene.GetLocationDetails.ViewModel(locationDisplay: .failure(error: userError))
    viewController.displayGetLocationDetails(viewModel: viewModel)
  }
}
