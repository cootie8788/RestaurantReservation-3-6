//
//  MessageTableViewCell.swift
//  RestaurantReservation
//
//  Created by Peggy Tsai on 2018/7/26.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var messageContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
