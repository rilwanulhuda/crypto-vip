//
//  HomeManager.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

typealias TopListResponseBlock = (FetchResult<TopListResponseModel, String>) -> Void

protocol IHomeManager: AnyObject {
    func getTopList(model: TopListRequestModel, completion: @escaping TopListResponseBlock)
}

class HomeManager: IHomeManager {
    weak var networkService: NetworkService?

    init(networkService: NetworkService?) {
        self.networkService = networkService
    }

    func getTopList(model: TopListRequestModel, completion: @escaping TopListResponseBlock) {
        let endpoint = Endpoint.topList(model: model)
        networkService?.request(endpoint: endpoint, completion: completion)
    }
}
