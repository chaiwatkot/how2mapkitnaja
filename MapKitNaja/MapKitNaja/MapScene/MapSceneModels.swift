//
//  MapSceneModels.swift
//  MapKitNaja
//
//  Created by CHAIWAT CHANTHASEN on 22/4/2563 BE.
//  Copyright (c) 2563 CHAIWAT CHANTHASEN. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct MapScene {
  struct GetTappedCoordinate {
    struct Request {
      let cgPoint: CGPoint
      let map: MKMapView
    }
    struct Response {
      let cgPoint: CGPoint
      let map: MKMapView
    }
    struct ViewModel {
      let location: CLLocation
      let coordinate: CLLocationCoordinate2D
    }
  }
  
  struct GetAnnotation {
    struct Request {
      let coordinate: CLLocationCoordinate2D
    }
    struct Response {
      let coordinate: CLLocationCoordinate2D
    }
    struct ViewModel {
      let pin: MKPointAnnotation
    }
  }
  
  struct UpdateRegion {
    struct Request {
      let coordinate: CLLocationCoordinate2D
    }
    struct Response {
      let coordinate: CLLocationCoordinate2D
      let regionMeter: Double
    }
    struct ViewModel {
      let coordinate: CLLocationCoordinate2D
      let regionMeter: Double
    }
  }
  
  struct GetCurrentLocationFromMap {
    struct Request {
      let coordinate: CLLocationCoordinate2D
    }
    struct Response {
      let location: CLLocation
    }
    struct ViewModel {
      let location: CLLocation
    }
  }
  
  struct GetLocationDetails {
    struct Request {
      let coordinate: CLLocationCoordinate2D
    }
    struct Response {
      let locationDetails: UserResult<GeoLocation.Response>
    }
    struct ViewModel {
      let locationDisplay: UserResult<String>
    }
  }
  
  struct GetDirection {
    struct Request {
      let currentLocation: CLLocation
      let tappedLocation: CLLocation
    }
    struct Response {
      let dierection: UserResult<MKDirections.Response>
    }
    struct ViewModel {
      let dierection: UserResult<MKDirections.Response>
    }
  }
  
  struct GetDistance {
    struct Request {
      let currentLocation: CLLocation
      let targetLocation: CLLocation
    }
    struct Response {
      let currentLocation: CLLocation
      let targetLocation: CLLocation
    }
    struct ViewModel {
      let title: String
      let description: String
      let buttonTitle: String
    }
  }
}
