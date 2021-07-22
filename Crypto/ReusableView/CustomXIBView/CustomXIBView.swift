//
//  CustomXIBView.swift
//  Crypto
//
//  Created by Rilwanul Huda on 22/07/21.
//

import UIKit

class CustomXIBView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setupComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setupComponent()
    }
    
    private func loadViewFromNib() {
        let nibName = String(describing: type(of: self))
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
    }
    
    func setupComponent() {
        //
    }
}
