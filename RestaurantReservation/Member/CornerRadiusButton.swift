//
//  CornerRadiusButton.swift
//  RestaurantReservation
//
//  Created by user on 2018/7/22.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

@IBDesignable
class CornerRadiusButton: UIButton {
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
