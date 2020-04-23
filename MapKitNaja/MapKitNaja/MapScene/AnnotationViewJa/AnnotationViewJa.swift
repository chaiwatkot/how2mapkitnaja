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

public struct AnnotationViewModel {
  let type: AnnotationType
  let details: String
  
  init(type: AnnotationType, details: String) {
    self.type = type
    self.details = details
  }
}


public final class AnnotationViewJa: MKAnnotationView {
  func updateUI(with annotation: MKAnnotation, viewModel: AnnotationViewModel) {
    self.annotation = annotation
    canShowCallout = true
    calloutOffset = CGPoint(x: -5, y: 5)
    let detailLabel = UILabel()
    detailLabel.textAlignment = .center
    detailLabel.numberOfLines = 0
    detailLabel.font = detailLabel.font.withSize(12)
    detailLabel.text = viewModel.details
    detailCalloutAccessoryView = detailLabel
    updateImage(type: viewModel.type)
  }
  
  func updateImage(type: AnnotationType) {
    switch type {
    case .currentUser:
      image = UIImage(named: "google-maps")
    case .other:
      image = UIImage(named: "restaurant")
    }
    frame.size = CGSize(width: 40, height: 40)
  }
}
