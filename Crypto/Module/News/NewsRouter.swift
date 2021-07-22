//
//  NewsRouter.swift
//  Cryptocurrencys
//
//  Created by Rilwanul Huda on 13/07/21.
//

import Foundation

protocol INewsRouter: AnyObject {
    //
}

class NewsRouter: INewsRouter {
    weak var view: NewsViewController?

    init(view: NewsViewController?) {
        self.view = view
    }
}
