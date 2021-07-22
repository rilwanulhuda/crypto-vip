//
//  Ext+UIApplication.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import UIKit

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
