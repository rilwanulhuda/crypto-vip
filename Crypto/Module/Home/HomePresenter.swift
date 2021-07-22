//
//  HomePresenter.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

protocol IHomePresenter: AnyObject {
    func presentTopList(result: FetchResult<TopListResponseModel, String>)
    func presentLoadMoreTopList(result: FetchResult<TopListResponseModel, String>)
    func presentTickerResponse(response: TickerResponseModel)
}

class HomePresenter: IHomePresenter {
    weak var view: HomeViewController?
    var topListCoins: [TopListModel] = []
    var indexPaths: [IndexPath] = []
    var errorMsg: String = ""
    var subscriptions: [String] = []
    
    init(view: HomeViewController?) {
        self.view = view
    }
    
    func presentTopList(result: FetchResult<TopListResponseModel, String>) {
        switch result {
        case .success(let successReponse):
            if let data = successReponse.data, data.count > 0 {
                subscriptions = []
                topListCoins = data.compactMap { TopListModel(data: $0) }
                let coinsCount = successReponse.metadata?.count ?? 0
                
                for coin in topListCoins {
                    let sub = "2~Coinbase~\(coin.symbol)~USD"
                    subscriptions.append(sub)
                }
                
                view?.displayTopList(topListCoins: topListCoins, coinsCount: coinsCount, subscriptions: subscriptions)
            } else {
                errorMsg = Messages.noCoinsFound
                view?.displayTopListError(message: errorMsg)
            }
            
        case .failure(let errorMsg):
            self.errorMsg = errorMsg
            view?.displayTopListError(message: self.errorMsg)
        }
    }
    
    func presentLoadMoreTopList(result: FetchResult<TopListResponseModel, String>) {
        switch result {
        case .success(let successResponse):
            if let data = successResponse.data, data.count > 0 {
                let newsCoins = data.compactMap { TopListModel(data: $0) }
                indexPaths = []
                
                for x in 0..<newsCoins.count {
                    let indexPath: IndexPath = [0, topListCoins.count + x]
                    indexPaths.append(indexPath)
                }
                
                for coin in newsCoins {
                    let sub = "2~Coinbase~\(coin.symbol)~USD"
                    subscriptions.append(sub)
                }
                
                topListCoins += newsCoins
                view?.displayLoadMoreTopList(topListCoins: topListCoins, indexPaths: indexPaths, subscriptions: subscriptions)
            }
            
        case .failure(let errorMsg):
            self.errorMsg = errorMsg
            view?.displayLoadMoreTopListError(message: self.errorMsg)
        }
    }
    
    func presentTickerResponse(response: TickerResponseModel) {
        for i in 0..<topListCoins.count {
            let coin = topListCoins[i]
            if coin.symbol == response.symbol {
                let updatedCoin = TopListModel(id: coin.id,
                                               symbol: coin.symbol,
                                               fullname: coin.fullname,
                                               price: response.price,
                                               openPrice: coin.openPrice)
                topListCoins[i] = updatedCoin
                let indexPath: IndexPath = [0, i]
                view?.displayRefreshCoins(topListCoins: topListCoins, at: indexPath)
                
                print("\(String(describing: coin.openPrice))\n\(response)\n\(updatedCoin)\n")
                return
            }
        }
    }
}
