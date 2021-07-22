//
//  HomeRouter.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

protocol IHomeRouter: AnyObject {
    func showNews(of symbol: String)
}

class HomeRouter: IHomeRouter {
    weak var view: HomeViewController?

    init(view: HomeViewController?) {
        self.view = view
    }

    func showNews(of symbol: String) {
        let module = CRRoute.news(parameters: [
            "symbol": symbol
        ])

        view?.navigate(type: .presentWithNavigation, module: module, completion: nil)
    }
}
