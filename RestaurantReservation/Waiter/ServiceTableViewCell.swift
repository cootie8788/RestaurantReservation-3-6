//
//  ServiceTableViewCell.swift
//  RestaurantReservation
//
//  Created by user on 2018/8/5.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

class ServiceTableViewCell: UITableViewCell {
    

    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
