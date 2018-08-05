//
//  OrdertotalTableViewCell.swift
//  RestaurantReservation
//
//  Created by 林沂諺 on 2018/8/2.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

class OrdertotalTableViewCell: UITableViewCell {

    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var view: RoundedPassCodeView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //table View 陰影效果
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 0.6 //陰影透明度
        view.layer.shadowRadius = 5 //應影半徑
        view.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
    }
}
