//
//  RatingTableViewCell.swift
//  RestaurantReservation
//
//  Created by Peggy Tsai on 2018/7/24.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit
import Cosmos

class RatingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var ratingUserLabel: UILabel!
    @IBOutlet weak var ratingManagerLabel: UILabel!
    @IBOutlet weak var managerReplyLabel: UILabel!
    @IBOutlet weak var commentSpaceView: UIView!
    @IBOutlet weak var comentDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
