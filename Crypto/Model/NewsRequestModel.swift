//
//  NewsRequestModel.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

struct NewsRequestModel {
    var lang: String
    var categories: String?

    init(lang: String = "EN", categories: String?) {
        self.lang = lang
        self.categories = categories
    }

    func parameters() -> [String: Any]? {
        if let categories = self.categories {
            return [
                "lang": lang,
                "categories": categories,
            ]
        } else {
            return [
                "lang": lang,
            ]
        }
    }
}
