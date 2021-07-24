//
//  HomeFactory.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

class HomeFactory {
    static func setup(parameters: [String: Any] = [:]) -> HomeViewController {
        let controller = HomeViewController()
        let router = HomeRouter(view: controller)
        let wsService = WSService.share
        let presenter = HomePresenter(view: controller)
        let manager = HomeManager(networkService: NetworkService.share)
        let interactor = HomeInteractor(presenter: presenter, manager: manager, wsService: wsService)
        
        interactor.parameters = parameters
        controller.interactor = interactor
        controller.router = router
        return controller
    }
}
