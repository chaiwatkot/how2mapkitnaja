//
//  MapSceneViewController.swift
//  MapKitNaja
//
//  Created by CHAIWAT CHANTHASEN on 22/4/2563 BE.
//  Copyright (c) 2563 CHAIWAT CHANTHASEN. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapSceneViewControllerInterface: class {
  func displayTappedCoordinate(viewModel: MapScene.GetTappedCoordinate.ViewModel)
  func displayAnnotationPin(viewModel: MapScene.GetAnnotation.ViewModel)
  func displayUpdateRegion(viewModel: MapScene.UpdateRegion.ViewModel)
  func displayGetCurrentLocationFromMap(viewModel: MapScene.GetCurrentLocationFromMap.ViewModel)
  func displayGetLocationFrom
}

final class MapSceneViewController: UIViewController, MapSceneViewControllerInterface {
  var interactor: MapSceneInteractorInterface!
  
  @IBOutlet private weak var mapView: MKMapView!
  @IBOutlet private weak var locationDescription: UILabel!
  
  private lazy var locationManager: CLLocationManager =  {
    return CLLocationManager()
  }()
  
  private var currentLocation: CLLocation?
  private var directionsArray: [MKDirections] = []
  
  // MARK: - Object lifecycle

  override func awakeFromNib() {
    super.awakeFromNib()
    configure(viewController: self)
  }

  // MARK: - Configuration

  private func configure(viewController: MapSceneViewController) {
    let presenter = MapScenePresenter()
    presenter.viewController = viewController

    let interactor = MapSceneInteractor()
    interactor.presenter = presenter
    interactor.worker = MapSceneWorker(store: MapSceneStore())

    viewController.interactor = interactor
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    checkPermissionLocation()
  }

  // MARK: - Event handling
  private func checkPermissionLocation() {
    if CLLocationManager.locationServicesEnabled() {
      setupMapView()
      setupLocationManager()
      checkLocationAuthorize()
    } else {
      presentOneButtonAlert()
    }
  }
  
  private func setupMapView() {
    mapView.delegate = self
    mapView.showsUserLocation = true
    let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture))
    mapView.addGestureRecognizer(longTapGesture)
  }
  
  private func setupLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  private func checkLocationAuthorize() {
    switch CLLocationManager.authorizationStatus() {
    case .authorizedAlways:
      setupCurrentTracking()
    case .authorizedWhenInUse:
      setupCurrentTracking()
    case .denied:
      presentOneButtonAlert()
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .restricted:
      presentOneButtonAlert()
    default: break
    }
  }
  
  @objc private func handleGesture(gestureReconizer: UILongPressGestureRecognizer) {
    let cgPoint = gestureReconizer.location(in: mapView)
    let request = MapScene.GetTappedCoordinate.Request(cgPoint: cgPoint, map: mapView)
    interactor.getTappedCoordinate(request: request)
  }
  
  private func addAnnotation(coordinate: CLLocationCoordinate2D) {
    let request = MapScene.GetAnnotation.Request(coordinate: coordinate)
    interactor.getAnnpotation(request: request)
  }
  
  private func updateRegion(coordinate: CLLocationCoordinate2D) {
    let request = MapScene.UpdateRegion.Request(coordinate: coordinate)
    interactor.updateRegion(request: request)
  }
  
  private func setupCurrentTracking() {
    guard let coordinate = locationManager.location?.coordinate else { return }
    locationManager.startUpdatingLocation()
    updateRegion(coordinate: coordinate)
    setupCurrentLocation(coordinate: coordinate)
  }
  
  private func setupCurrentLocation(coordinate: CLLocationCoordinate2D) {
    let request = MapScene.GetCurrentLocationFromMap.Request(coordinate: coordinate)
    interactor.getCurrentLocationFromMap(request: request)
  }
  
  // MARK: - Display logic
  func displayTappedCoordinate(viewModel: MapScene.GetTappedCoordinate.ViewModel) {
    mapView.removeOverlays(mapView.overlays)
    locationManager.startUpdatingLocation()
    addAnnotation(coordinate: viewModel.coordinate)
    updateRegion(coordinate: viewModel.coordinate)
  }
  
  func displayAnnotationPin(viewModel: MapScene.GetAnnotation.ViewModel) {
    mapView.removeAnnotations(mapView.annotations)
    mapView.addAnnotation(viewModel.pin)
  }
  
  func displayUpdateRegion(viewModel: MapScene.UpdateRegion.ViewModel) {
    let region = MKCoordinateRegion(center: viewModel.coordinate, latitudinalMeters: viewModel.regionMeter, longitudinalMeters: viewModel.regionMeter)
    mapView.setRegion(region, animated: true)
  }
  
  func displayGetCurrentLocationFromMap(viewModel: MapScene.GetCurrentLocationFromMap.ViewModel) {
    currentLocation = viewModel.location
  }
}

extension MapSceneViewController: MKMapViewDelegate {
  
}

extension MapSceneViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    checkLocationAuthorize()
  }
}
