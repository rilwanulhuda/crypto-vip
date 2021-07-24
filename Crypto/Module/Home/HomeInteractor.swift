//
//  HomeInteractor.swift
//  Cryptocurrencys
//
//  Created by Rilwanul Huda on 13/07/21.
//

import Foundation
import Starscream

protocol IHomeInteractor: AnyObject {
    var parameters: [String: Any]? { get }
    var page: Int { get set }
    var coinsCount: Int { get set }
    var currentCoinsCount: Int { get set }
    var subscriptions: [String] { get set }
    var isWsConnected: Bool { get }
    
    func getTopList()
    func loadMoreTopList()
    func couldLoadMore() -> Bool
    func sendSubscription(action: SubActionType)
}

class HomeInteractor: IHomeInteractor {
    var presenter: IHomePresenter?
    var manager: IHomeManager?
    var wsService: IWSService?
    var parameters: [String: Any]?
    var page: Int = 1
    var coinsCount: Int = 0
    var currentCoinsCount: Int = 0
    var subscriptions: [String] = []
    var isWsConnected: Bool = false
    
    init(presenter: IHomePresenter?, manager: IHomeManager?, wsService: IWSService?) {
        self.presenter = presenter
        self.manager = manager
        self.wsService = wsService
    }
    
    func getTopList() {
        sendSubscription(action: .unsubscribe)
        
        page = 1
        coinsCount = 0
        currentCoinsCount = 0
        let model = TopListRequestModel(page: page)
        
        manager?.getTopList(model: model, completion: { [weak self] result in
            guard let self = self else { return }
            self.presenter?.presentTopList(result: result)
        })
    }
    
    func loadMoreTopList() {
        page += 1
        let model = TopListRequestModel(page: page)
        
        manager?.getTopList(model: model, completion: { [weak self] result in
            guard let self = self else { return }
            self.presenter?.presentLoadMoreTopList(result: result)
        })
    }
    
    func couldLoadMore() -> Bool {
        return currentCoinsCount < coinsCount
    }
    
    func sendSubscription(action: SubActionType) {
        wsService?.sendSubscription(action: action, subscriptions: subscriptions)
    }
}

extension HomeInteractor: WSServiceDelegate {
    func didUpdatedConnectionStatus(isConnected: Bool) {
        sendSubscription(action: .subscribe)
    }
    
    func didReceiveTickerResponse(response: TickerResponseModel) {
        presenter?.presentTickerResponse(response: response)
    }
}
