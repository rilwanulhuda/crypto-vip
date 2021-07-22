//
//  NewsPresenter.swift
//  Cryptocurrencys
//
//  Created by Rilwanul Huda on 13/07/21.
//

import Foundation

protocol INewsPresenter: AnyObject {
    func presentNews(result: FetchResult<NewsResponseModel, String>)
}

class NewsPresenter: INewsPresenter {
    weak var view: NewsViewController?
    var news: [NewsModel] = []
    var errorMsg: String = ""

    init(view: NewsViewController?) {
        self.view = view
    }

    func presentNews(result: FetchResult<NewsResponseModel, String>) {
        switch result {
        case .success(let successResponse):
            if let data = successResponse.data, data.count > 0 {
                news = data.compactMap { NewsModel(data: $0) }
                view?.displayNews(news: news)
            } else {
                errorMsg = Messages.noNewsFound
                view?.displayNewsError(message: errorMsg)
            }

        case .failure(let errorMsg):
            self.errorMsg = errorMsg
            view?.displayNewsError(message: self.errorMsg)
        }
    }
}
