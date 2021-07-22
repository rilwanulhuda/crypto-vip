//
//  Messages.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

struct Messages {
    static let loading = "Please Wait.."
    static let noCoinsFound = "No Coins Found"
    static let noNewsFound = "No News Found"
    static let noInternet = "No Internet Connection"
    static let unknownError = "Unknown Error"
    
    static let generalError: String = {
        if NetworkStatus.isInternetAvailable {
            return unknownError
        }
        
        return noInternet
    }()
}
