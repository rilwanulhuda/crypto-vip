//
//  SubscriptionModel.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

enum SubActionType: String {
    case subscribe = "SubAdd"
    case unsubscribe = "SubRemove"
}

struct SubscriptionModel {
    var action: SubActionType
    var subscription: [String]

    func parameters() -> [String: Any]? {
        return [
            "action": action.rawValue,
            "subs": subscription
        ]
    }
}

struct TickerResponseModel {
    var symbol: String
    var price: Double
}
