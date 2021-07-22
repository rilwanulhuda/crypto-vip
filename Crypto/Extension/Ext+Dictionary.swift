//
//  Ext+Dictionary.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

extension Dictionary {
    var toData: Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return nil
        }
        
        return data
    }
    
    var toJSON: String? {
        guard let data = toData else { return nil }
        let jsonString = String(data: data, encoding: .utf8)
        return jsonString
    }
}
