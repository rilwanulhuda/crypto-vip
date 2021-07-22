//
//  NewsInteractor.swift
//  Cryptocurrencys
//
//  Created by Rilwanul Huda on 13/07/21.
//

import Foundation

protocol INewsInteractor: AnyObject {
    var parameters: [String: Any]? { get }

    func getNews()
}

class NewsInteractor: INewsInteractor {
    var presenter: INewsPresenter?
    var manager: INewsManager?
    var parameters: [String: Any]?

    init(presenter: INewsPresenter?, manager: INewsManager?) {
        self.presenter = presenter
        self.manager = manager
    }

    func getNews() {
        let symbol = parameters?["symbol"] as? String
        let model = NewsRequestModel(categories: symbol)

        manager?.getNews(model: model, completion: { [weak self] result in
            guard let self = self else { return }
            self.presenter?.presentNews(result: result)
        })
    }
}
