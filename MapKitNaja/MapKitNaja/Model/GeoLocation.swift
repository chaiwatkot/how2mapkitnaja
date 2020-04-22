//
//  GeoLocation.swift
//  MapKitNaja
//
//  Created by CHAIWAT CHANTHASEN on 23/4/2563 BE.
//  Copyright © 2563 CHAIWAT CHANTHASEN. All rights reserved.
//

import Foundation
import CoreLocation

public struct GeoLocation {
  public struct Request {
    let location: CLLocation
    
    init(location: CLLocation) {
      self.location = location
    }
  }
  
  public struct Response {
    let locationDetails: [CLPlacemark]?
    
    init(locationDetails: [CLPlacemark]?) {
      self.locationDetails = locationDetails
    }
  }
}

public struct LocationDisplay {
  public let placeName: String
  public let streetNumber: String
  public let streetName: String
  
  init(placeName: String, streetNumber: String, streetName: String) {
    self.placeName = placeName
    self.streetNumber = streetNumber
    self.streetName = streetName
  }
}
