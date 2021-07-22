//
//  MockResponse.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

enum MockResponseFileName: String {
    case topListSuccessResponse = "TopListSuccessResponse"
    case topListSuccessResponseNoData = "TopListSuccessResponseNoData"
    case topListPageTwoSuccessResponse = "TopListPageTwoSuccessResponse"
    case topListPageThreeSuccessResponse = "TopListPageThreeSuccessResponse"
    case newsSuccessResponse = "NewsSuccessResponse"
    case newsSuccessResponseNoData = "NewsSuccessResponseNoData"
}

func mockResponse<T: Decodable>(of type: T.Type, filename: MockResponseFileName) -> T? {
    guard let path = Bundle.main.path(forResource: filename.rawValue, ofType: "json") else {
        return nil
    }

    do {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        let response = try? jsonDecoder().decode(T.self, from: data)
        return response
    } catch {
        return nil
    }
}
