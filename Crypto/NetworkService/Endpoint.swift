//
//  Endpoint.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Alamofire

enum Endpoint {
    case topList(model: TopListRequestModel)
    case news(model: NewsRequestModel)
}

extension Endpoint: IEndpoint {
    var url: String {
        return APIConstant.apiBaseUrl + path
    }

    private var path: String {
        switch self {
        case .topList:
            return "/data/top/totaltoptiervolfull"
        case .news:
            return "/data/v2/news/"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: Parameters? {
        switch self {
        case .topList(let model):
            return model.parameters()
        case .news(let model):
            return model.parameters()
        }
    }

    var encoding: ParameterEncoding {
        return URLEncoding.queryString
    }

    var headers: HTTPHeaders? {
        return [
            "content-type": "application/json",
            "authorization": "Apikey \(APIConstant.apiKey)"
        ]
    }
}
