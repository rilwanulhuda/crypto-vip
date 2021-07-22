//
//  NewsResponseModel.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

struct NewsResponseModel: Codable {
    var message: String?
    var data: [NewsData]?

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case data = "Data"
    }
}

struct NewsData: Codable {
    var id: String?
    var title: String?
    var body: String?
    var sourceInfo: NewsSourceInfo?

    enum CodingKeys: String, CodingKey {
        case id, title, body
        case sourceInfo = "source_info"
    }
}

struct NewsSourceInfo: Codable {
    var name: String?

    enum CodingKeys: String, CodingKey {
        case name
    }
}
