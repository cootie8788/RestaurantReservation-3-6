//
//  OldDrderDetailTableViewCell.swift
//  RestaurantReservation
//
//  Created by 林沂諺 on 2018/7/25.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

class OldDrderDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foofPrice: UILabel!
    @IBOutlet weak var foodCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
