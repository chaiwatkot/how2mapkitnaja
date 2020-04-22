//
//  AnnotationView.swift
//  MapKitNaja
//
//  Created by CHAIWAT CHANTHASEN on 23/4/2563 BE.
//  Copyright © 2563 CHAIWAT CHANTHASEN. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

public enum AnnotationType {
  case currentUser
  case other
}

public final class AnnotationViewJa: MKAnnotationView {
  func updateUI(with annotation: MKAnnotation, type: AnnotationType) {
    self.annotation = annotation
    switch type {
    case .currentUser:
      image = UIImage(named: "google-maps")
    case .other:
      image = UIImage(named: "restaurant")
    }
    frame.size = CGSize(width: 40, height: 40)
  }
}
