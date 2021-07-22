//
//  APIConstant.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

struct APIConstant {
    static let apiKey = "c5c142df1e0c950e1276c73daebf167d5268ca5bd4240188bbdb3405ca96a5b0"
    static let apiBaseUrl = "https://min-api.cryptocompare.com"
    static let wsUrlString = "wss://streamer.cryptocompare.com/v2" + "?api_key=\(apiKey)"
}
