//
//  TopListResponseModel.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

struct TopListResponseModel: Codable {
    var message: String?
    var metadata: TopListMetaData?
    var data: [TopListData]?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case metadata = "MetaData"
        case data = "Data"
    }
}

struct TopListMetaData: Codable {
    var count: Int?

    enum CodingKeys: String, CodingKey {
        case count = "Count"
    }
}

struct TopListData: Codable {
    var coinInfo: TopListCoinInfo?
    var display: TopListDisplay?

    enum CodingKeys: String, CodingKey {
        case coinInfo = "CoinInfo"
        case display = "DISPLAY"
    }
}

struct TopListCoinInfo: Codable {
    var id: String?
    var name: String?
    var fullname: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case fullname = "FullName"
    }
}

struct TopListRaw: Codable {
    var usd: TopListUSD?

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

struct TopListDisplay: Codable {
    var usd: TopListUSD?

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

struct TopListUSD: Codable {
    var price: String?
    var change24Hour: String?
    var pctChange24Hour: String?
    var open24Hour: String?

    enum CodingKeys: String, CodingKey {
        case price = "PRICE"
        case pctChange24Hour = "CHANGEPCT24HOUR"
        case change24Hour = "CHANGE24HOUR"
        case open24Hour = "OPEN24HOUR"
    }
}
