//
//  NewsFactory.swift
//  Cryptocurrencys
//
//  Created by Rilwanul Huda on 13/07/21.
//

import Foundation

class NewsFactory {
    static func setup(parameters: [String: Any] = [:]) -> NewsViewController {
        let controller = NewsViewController()
        let router = NewsRouter(view: controller)
        let presenter = NewsPresenter(view: controller)
        let manager = NewsManager(networkService: NetworkService.share)
        let interactor = NewsInteractor(presenter: presenter, manager: manager)

        interactor.parameters = parameters
        controller.interactor = interactor
        controller.router = router
        return controller
    }
}
