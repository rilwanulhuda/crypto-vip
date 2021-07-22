//
//  TopListModel.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import Foundation

struct TopListModel {
    var id: String
    var symbol: String
    var fullname: String
    var price: String
    var changes: String
    var openPrice: Double?

    init(data: TopListData) {
        self.id = data.coinInfo?.id ?? "0"
        self.symbol = data.coinInfo?.name ?? "-"
        self.fullname = data.coinInfo?.fullname ?? "-"
        self.price = data.display?.usd?.price ?? "n/a"

        if let usd = data.display?.usd {
            let change24HourUsd = usd.change24Hour ?? ""
            let change24Hour = change24HourUsd.replacingOccurrences(of: "$ ", with: "")
            let pctChange24Hour = usd.pctChange24Hour ?? ""

            if !change24Hour.contains("-") {
                self.changes = "+\(change24Hour)(+\(pctChange24Hour)%)"
            } else {
                self.changes = "\(change24Hour)(\(pctChange24Hour)%)"
            }

            var open24Hour = usd.open24Hour?.replacingOccurrences(of: "$ ", with: "")
            open24Hour = open24Hour?.replacingOccurrences(of: ",", with: "")
            self.openPrice = Double(open24Hour ?? "0")
        } else {
            self.changes = "n/a"
        }
    }

    init(id: String, symbol: String, fullname: String, price: Double, openPrice: Double?) {
        self.id = id
        self.symbol = symbol
        self.fullname = fullname
        self.price = "$ \(price)"
        self.openPrice = openPrice

        let op = openPrice ?? 0
        var changePrice = price - op

        if op.decimalCount() > 0 {
            let pows = pow(Double(10), Double(op.decimalCount()))
            changePrice = (changePrice * pows).rounded() / pows
        }

        let pctChange = (((changePrice / op) * 100) * 100).rounded() / 100

        if !"\(changePrice)".contains("-") {
            self.changes = "+\(changePrice)(+\(pctChange)%)"
        } else {
            self.changes = "\(changePrice)(\(pctChange)%)"
        }
    }
}
