//
//  CRRoute.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import UIKit

enum CRRoute: IRouter {
    case home
    case news(parameters: [String: Any])
}

extension CRRoute {
    var module: UIViewController? {
        switch self {
        case .home:
            return HomeFactory.setup()
        case .news(let parameters):
            return NewsFactory.setup(parameters: parameters)
        }
    }
}
