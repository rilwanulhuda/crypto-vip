//
//  NewsManager.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

typealias NewsResponseBlock = (FetchResult<NewsResponseModel, String>) -> Void

protocol INewsManager: AnyObject {
    func getNews(model: NewsRequestModel, completion: @escaping NewsResponseBlock)
}

class NewsManager: INewsManager {
    weak var networkService: NetworkService?

    init(networkService: NetworkService?) {
        self.networkService = networkService
    }

    func getNews(model: NewsRequestModel, completion: @escaping NewsResponseBlock) {
        let endpoint = Endpoint.news(model: model)
        networkService?.request(endpoint: endpoint, completion: completion)
    }
}
