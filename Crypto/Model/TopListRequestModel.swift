//
//  TopListRequestModel.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

struct TopListRequestModel {
    var limit: Int
    var page: Int
    var tsym: String

    init(limit: Int = 20, page: Int, tsym: String = "USD") {
        self.limit = limit
        self.page = page - 1
        self.tsym = tsym
    }

    func parameters() -> [String: Any]? {
        return [
            "limit": limit,
            "page": page,
            "tsym": tsym,
        ]
    }
}
