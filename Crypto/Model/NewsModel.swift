//
//  NewsModel.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

struct NewsModel {
    var title: String
    var body: String
    var source: String

    init(data: NewsData) {
        self.title = data.title ?? "n/a"
        self.body = data.body ?? "n/a"
        self.source = data.sourceInfo?.name ?? "n/a"
    }
}
