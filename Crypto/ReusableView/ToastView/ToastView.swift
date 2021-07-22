//
//  ToastView.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import UIKit

class ToastView: CustomXIBView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func setupComponent() {
        contentView.fixInView(self)
    }
}
