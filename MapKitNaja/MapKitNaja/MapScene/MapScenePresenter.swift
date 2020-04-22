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
  func presentAnnotation(response: MapScene.GetAnnotation.Response)
  func presentUpdateRegion(response: MapScene.UpdateRegion.Response)
  func presentGetCurrentLocation(response: MapScene.GetCurrentLocationFromMap.Response)
}

final class MapScenePresenter: MapScenePresenterInterface {
  weak var viewController: MapSceneViewControllerInterface!

  // MARK: - Presentation logic
  func presentTappedCoordinate(response: MapScene.GetTappedCoordinate.Response) {
    let tappedCoordinate = response.map.convert(response.cgPoint, toCoordinateFrom: response.map)
    let viewModel = MapScene.GetTappedCoordinate.ViewModel(coordinate: tappedCoordinate)
    viewController.displayTappedCoordinate(viewModel: viewModel)
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
}
