//
//  MapScenePresenter.swift
//  MapKitNaja
//
//  Created by CHAIWAT CHANTHASEN on 22/4/2563 BE.
//  Copyright (c) 2563 CHAIWAT CHANTHASEN. All rights reserved.
//

import UIKit

protocol MapScenePresenterInterface {
  func presentSomething(response: MapScene.Something.Response)
}

class MapScenePresenter: MapScenePresenterInterface {
  weak var viewController: MapSceneViewControllerInterface!

  // MARK: - Presentation logic

  func presentSomething(response: MapScene.Something.Response) {
    // NOTE: Format the response from the Interactor and pass the result back to the View Controller. The resulting view model should be using only primitive types. Eg: the view should not need to involve converting date object into a formatted string. The formatting is done here.

    let viewModel = MapScene.Something.ViewModel()
    viewController.displaySomething(viewModel: viewModel)
  }
}
