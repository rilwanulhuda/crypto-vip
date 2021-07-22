//
//  Ext+String.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

extension String {
    var removeBackslash: String {
        return replacingOccurrences(of: "\\/", with: "/")
    }
    
    func toDictionary() -> [String: Any]? {
        if let data = data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    func toData() -> Data? {
        return self.data(using: .utf8)
    }
}
