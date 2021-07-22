//
//  Ext+Double.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

extension Double {
    func decimalCount() -> Int {
        if self == Double(Int(self)) {
            return 0
        }
        
        let integerString = String(Int(self))
        let doubleString = String(Double(self))
        let decimalCount = doubleString.count - integerString.count - 1
        
        return decimalCount
    }
}
