//
//  Ext+UIButton.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import UIKit

extension UIButton {
    func touchUpInside(_ target: Any?, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside)
    }
}
