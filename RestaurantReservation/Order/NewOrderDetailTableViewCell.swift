//
//  NewOrderDetailTableViewCell.swift
//  RestaurantReservation
//
//  Created by 林沂諺 on 2018/7/24.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//
// 定位detail Cell
import UIKit

class NewOrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var foodItems: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
