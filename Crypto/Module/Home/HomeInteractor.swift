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
    var webSocket: WebSocket?
    var parameters: [String: Any]?
    var page: Int = 1
    var coinsCount: Int = 0
    var currentCoinsCount: Int = 0
    var subscriptions: [String] = []
    var isWsConnected: Bool = false
    
    init(presenter: IHomePresenter?, manager: IHomeManager?) {
        self.presenter = presenter
        self.manager = manager
        setupWebSocket()
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
        guard !subscriptions.isEmpty, isWsConnected else { return }
        let model = SubscriptionModel(action: action, subscription: subscriptions)
        let json = model.parameters()?.toJSON
        webSocket?.write(string: json!)
    }
    
    func setupWebSocket() {
        var request = URLRequest(url: URL(string: APIConstant.wsUrlString)!)
        request.timeoutInterval = 5
        webSocket = WebSocket(request: request)
        webSocket?.delegate = self
        webSocket?.connect()
    }
}

extension HomeInteractor: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isWsConnected = true
            sendSubscription(action: .subscribe)
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isWsConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
            
        case .text(let string):
            guard let dict = string.toDictionary(),
                  let type = dict["TYPE"] as? String, type == "2",
                  let flags = dict["FLAGS"] as? Int, flags == 2 else { return }
            
            if let symbol = dict["FROMSYMBOL"] as? String, let price = dict["PRICE"] as? Double {
                let tickerResponse = TickerResponseModel(symbol: symbol, price: price)
                presenter?.presentTickerResponse(response: tickerResponse)
            }
            
        case .binary(let data):
            print("Receive data: \(data.count)")
            
        case .pong:
            print("pong")
            
        case .ping:
            print("ping")
            
        case .error(let error):
            isWsConnected = false
            print(error?.localizedDescription ?? Messages.generalError)
            
        case .viabilityChanged:
            print("viabilityChanged")
            
        case .reconnectSuggested:
            isWsConnected = false
            print("reconnectedSuggested")
            
        case .cancelled:
            isWsConnected = false
            print("connection cancelled")
        }
    }
}
