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
  func displayGetLocationDetails(viewModel: MapScene.GetLocationDetails.ViewModel)
  func displayAnnotationPin(viewModel: MapScene.GetAnnotation.ViewModel)
  func displayUpdateRegion(viewModel: MapScene.UpdateRegion.ViewModel)
  func displayGetCurrentLocationFromMap(viewModel: MapScene.GetCurrentLocationFromMap.ViewModel)
  func displayGetDirection(viewModel: MapScene.GetDirection.ViewModel)
}

final class MapSceneViewController: UIViewController, MapSceneViewControllerInterface {
  var interactor: MapSceneInteractorInterface!
  
  @IBOutlet private weak var mapView: MKMapView!
  @IBOutlet private weak var locationDescription: UILabel!
  
  private lazy var locationManager: CLLocationManager =  {
    return CLLocationManager()
  }()
  
  private var currentLocation: CLLocation?
  private var tappedLocation: CLLocation?
  private var currentAnnotationViewModel: AnnotationViewModel?
  private var targetAnnotationViewModel: AnnotationViewModel?
  private var distance: String?
  
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
  
  private func getLocationDetails(coordinate: CLLocationCoordinate2D, type: AnnotationType) {
    let request = MapScene.GetLocationDetails.Request(coordinate: coordinate, type: type)
    interactor.getLocationDetails(request: request)
  }
  
  private func getAnnotation(locationDetail: GeoLocation.Response, type: AnnotationType) {
    let request = MapScene.GetAnnotation.Request(locationDetails: locationDetail, type: type)
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
    getLocationDetails(coordinate: coordinate, type: .currentUser)
  }
  
  private func setupCurrentLocation(coordinate: CLLocationCoordinate2D) {
    let request = MapScene.GetCurrentLocationFromMap.Request(coordinate: coordinate)
    interactor.getCurrentLocationFromMap(request: request)
  }
  
  private func getDirection() {
    guard let current = currentLocation, let target = tappedLocation else {
      presentOneButtonAlert()
      return
    }
    let request = MapScene.GetDirection.Request(currentLocation: current, tappedLocation: target)
    interactor.getDirection(request: request)
  }
  
  // MARK: - Action func
  @IBAction private func didTappedGooooooo() {
    getDirection()
  }
  
  // MARK: - Display logic
  func displayTappedCoordinate(viewModel: MapScene.GetTappedCoordinate.ViewModel) {
    tappedLocation = viewModel.targetLocation
    currentLocation = viewModel.currentLocation
    mapView.removeOverlays(mapView.overlays)
    locationManager.startUpdatingLocation()
    getLocationDetails(coordinate: viewModel.coordinate, type: .other)
    updateRegion(coordinate: viewModel.coordinate)
  }
  
  func displayAnnotationPin(viewModel: MapScene.GetAnnotation.ViewModel) {
    switch viewModel.annotationViewModel.type {
    case .currentUser:
      currentAnnotationViewModel = viewModel.annotationViewModel
    case .other:
      mapView.removeAnnotations(mapView.annotations)
      targetAnnotationViewModel = viewModel.annotationViewModel
    }
    if let pin = viewModel.pin {
      mapView.addAnnotation(pin)
    }
  }
  
  func displayUpdateRegion(viewModel: MapScene.UpdateRegion.ViewModel) {
    let region = MKCoordinateRegion(center: viewModel.coordinate, latitudinalMeters: viewModel.regionMeter, longitudinalMeters: viewModel.regionMeter)
    mapView.setRegion(region, animated: true)
  }
  
  func displayGetCurrentLocationFromMap(viewModel: MapScene.GetCurrentLocationFromMap.ViewModel) {
    currentLocation = viewModel.location
  }
  
  func displayGetLocationDetails(viewModel: MapScene.GetLocationDetails.ViewModel) {
    switch viewModel.result {
    case .success(result: let details):
      getAnnotation(locationDetail: details.locationDetails, type: details.type)
    case .failure(error: let userError):
      presentOneButtonAlert(title: userError.title, message: userError.message)
    }
  }
  
  func displayGetDirection(viewModel: MapScene.GetDirection.ViewModel) {
    switch viewModel.dierection {
    case .success(result: let direction):
      for route in direction.routes {
        mapView.addOverlay(route.polyline)
        updateRegion(coordinate: route.polyline.coordinate)
      }
    case .failure(error: let userError):
      presentOneButtonAlert(title: userError.title, message: userError.message)
    }
  }
}

// MARK: - extension
extension MapSceneViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let annotationView = AnnotationViewJa()
    if annotation is MKUserLocation {
      annotationView.updateImage(type: .currentUser)
      guard let annotationViewModel = self.currentAnnotationViewModel else { return annotationView }
      annotationView.updateUI(with: annotation, viewModel: annotationViewModel)
    } else {
      guard let annotationViewModel = self.targetAnnotationViewModel else { return nil }
      annotationView.updateUI(with: annotation, viewModel: annotationViewModel)
    }
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if let polyLineOverlay = overlay as? MKPolyline {
      let renderer = MKPolylineRenderer(overlay: polyLineOverlay)
      renderer.strokeColor = .purple
      return renderer
    } else {
      return MKOverlayRenderer(overlay: overlay)
    }
  }
}

extension MapSceneViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    checkLocationAuthorize()
  }
}
