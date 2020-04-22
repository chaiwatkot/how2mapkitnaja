//
//  UIViewControllerJa.swift
//  MapKitNaja
//
//  Created by CHAIWAT CHANTHASEN on 22/4/2563 BE.
//  Copyright © 2563 CHAIWAT CHANTHASEN. All rights reserved.
//

import UIKit

public extension UIViewController {
  func presentOneButtonAlert(title: String? = ErrorMessageSame.error, message: String? = ErrorMessageSame.errorMessage, buttonTitle: String? = ErrorMessageSame.okJa, withHandler handler: ((UIAlertAction) -> Void)? = nil) {
    let alertController = UIAlertController().oneButtonAlert(title: title, message: message, buttonTitle: buttonTitle, withHandler: handler)
    present(alertController, animated: true, completion: nil)
  }
}

public extension UIAlertController {
  func oneButtonAlert(title: String? = ErrorMessageSame.error, message: String? = ErrorMessageSame.errorMessage, buttonTitle: String? = ErrorMessageSame.okJa, withHandler handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
    let buttonActionTitle = buttonTitle ?? "OK"
    let buttonAction = UIAlertAction(title: buttonActionTitle, style: .default, handler: handler)
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(buttonAction)
        
    return alert
  }

}
