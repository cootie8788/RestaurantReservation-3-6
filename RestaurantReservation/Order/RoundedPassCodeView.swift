//
//  RoundedPassCodeView.swift
//  TocuhIdPassword
//
//  Created by 林沂諺 on 2018/7/16.
//  Copyright © 2018年 AppleCode. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable
class RoundedPassCodeView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
}

