//
//  TopListTableViewCell.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import UIKit

class TopListTableViewCell: UITableViewCell {
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tickerView: UIView!
    @IBOutlet weak var changesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tickerView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
 
    func setupView(coin: TopListModel) {
        symbolLabel.text = coin.symbol
        fullNameLabel.text = coin.fullname
        priceLabel.text = coin.price
        changesLabel.text = coin.changes
        
        if coin.changes == "n/a" {
            tickerView.backgroundColor = Colors.lightGray
        } else {
            tickerView.backgroundColor = coin.changes.contains("-") ? Colors.red : Colors.green
        }
    }
}
