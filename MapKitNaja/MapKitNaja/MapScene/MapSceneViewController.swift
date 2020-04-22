//
//  MapSceneViewController.swift
//  MapKitNaja
//
//  Created by CHAIWAT CHANTHASEN on 22/4/2563 BE.
//  Copyright (c) 2563 CHAIWAT CHANTHASEN. All rights reserved.
//

import UIKit

protocol MapSceneViewControllerInterface: class {
  func displaySomething(viewModel: MapScene.Something.ViewModel)
}

class MapSceneViewController: UIViewController, MapSceneViewControllerInterface {
  var interactor: MapSceneInteractorInterface!
  var router: MapSceneRouterInterface!

  // MARK: - Object lifecycle

  override func awakeFromNib() {
    super.awakeFromNib()
    configure(viewController: self)
  }

  // MARK: - Configuration

  private func configure(viewController: MapSceneViewController) {
    let router = MapSceneRouter()
    router.viewController = viewController

    let presenter = MapScenePresenter()
    presenter.viewController = viewController

    let interactor = MapSceneInteractor()
    interactor.presenter = presenter
    interactor.worker = MapSceneWorker(store: MapSceneStore())

    viewController.interactor = interactor
    viewController.router = router
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    doSomethingOnLoad()
  }

  // MARK: - Event handling

  func doSomethingOnLoad() {
    // NOTE: Ask the Interactor to do some work

    let request = MapScene.Something.Request()
    interactor.doSomething(request: request)
  }

  // MARK: - Display logic

  func displaySomething(viewModel: MapScene.Something.ViewModel) {
    // NOTE: Display the result from the Presenter

    // nameTextField.text = viewModel.name
  }

  // MARK: - Router

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    router.passDataToNextScene(segue: segue)
  }

  @IBAction func unwindToMapSceneViewController(from segue: UIStoryboardSegue) {
    print("unwind...")
    router.passDataToNextScene(segue: segue)
  }
}
