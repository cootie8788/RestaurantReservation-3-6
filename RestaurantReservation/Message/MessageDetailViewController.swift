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
    @IBOutlet weak var messageCouponBtn: UIButton!
    @IBOutlet weak var messageEditBtn: UIBarButtonItem!
    
    @IBAction func messageCouponBtnPress(_ sender: Any) {
    }
    
    var messageInfo: MessageInfo?
    var messageImage: UIImage?
    var member_authority_id: Int?
    
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
        
        member_authority_id = 3
        
        if member_authority_id == 1 {
            navigationItem.title = "優惠訊息"
            
        } else if member_authority_id == 3 {
            messageCouponBtn.isHidden = true
            navigationItem.title = "優惠管理"
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(MessageDetailViewController.editBarBtnFnc))
        }
    }
    
    @objc func editBarBtnFnc(){
        print("Nam1BarBtnKlk")
        
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "messageEditStoryboard") else{
            assertionFailure("controller can't find!!")
            return
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
