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
}

final class MapScenePresenter: MapScenePresenterInterface {
  
  weak var viewController: MapSceneViewControllerInterface!

  // MARK: - Presentation logic
  func presentTappedCoordinate(response: MapScene.GetTappedCoordinate.Response) {
    let viewModel = MapScene.GetTappedCoordinate.ViewModel(targetLocation: response.targetLocation, currentLocation: response.currentLocation, coordinate: response.coordinate)
    viewController.displayTappedCoordinate(viewModel: viewModel)
  }
  
  func presentGetLocationDetails(response: MapScene.GetLocationDetails.Response) {
    switch response.result {
    case .success(result: let locationDetails):
      let viewModel = MapScene.GetLocationDetails.ViewModel(result: .success(result: locationDetails))
      viewController.displayGetLocationDetails(viewModel: viewModel)
    case .failure(error: let userError):
      presentGetLocationDetailsError(userError: userError)
    }
  }

  func presentAnnotation(response: MapScene.GetAnnotation.Response) {
    guard let detail = response.locationDetails.locationDetails?.first else { return }
    var placeName: String = detail.thoroughfare ?? ""
    if let locationName = detail.name {
      placeName = locationName
    }
    var details: String = ""
    if let distance = response.distance {
      let distanceString = String(format: "%.2f", distance / 1000 )
      details = "\(placeName) \n distance \(distanceString) km.!!"
    } else {
      details = placeName
    }
    let annotationViewModel = AnnotationViewModel(type: response.type,
                                                  details: details)
    
    switch response.type {
    case .currentUser:
      let viewModel = MapScene.GetAnnotation.ViewModel(annotationViewModel: annotationViewModel, pin: nil)
      viewController.displayAnnotationPin(viewModel: viewModel)
    case .other:
      let annotation = MKPointAnnotation()
      annotation.coordinate = response.location.coordinate
      let viewModel = MapScene.GetAnnotation.ViewModel(annotationViewModel: annotationViewModel, pin: annotation)
      viewController.displayAnnotationPin(viewModel: viewModel)
    }
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
  
  // MARK: - private func
  private func presentGetLocationDetailsError(userError: UserError = UserError()) {
    let viewModel = MapScene.GetLocationDetails.ViewModel(result: .failure(error: userError))
    viewController.displayGetLocationDetails(viewModel: viewModel)
  }
}
