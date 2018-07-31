//
//  MessageDetailViewController.swift
//  RestaurantReservation
//
//  Created by Peggy Tsai on 2018/7/30.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {

    @IBOutlet weak var messageDetailImageView: UIImageView!
    @IBOutlet weak var messageDetailTitleLabel: UILabel!
    @IBOutlet weak var messageDetailContentLabel: UILabel!
    @IBOutlet weak var messageDetailData: UILabel!
    
    @IBAction func messageCouponBtnPress(_ sender: Any) {
    }
    
    var messageInfo: MessageInfo?
    var messageImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let messageInfo = messageInfo{
            messageDetailTitleLabel.text = messageInfo.message_title
            messageDetailContentLabel.text = messageInfo.message_content
            messageDetailData.text = "\(messageInfo.coupon_start) - \(messageInfo.coupon_end)"
        }
        
        if let messageImage = messageImage {
            messageDetailImageView.image = messageImage
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
