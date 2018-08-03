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
    @IBOutlet weak var messageEditBtn: UIBarButtonItem!

    @IBOutlet weak var messageCouponBtn: UIButton!
    
    @IBAction func messageCouponBtnPress(_ sender: Any) {
    }
    
    var messageInfo: MessageInfo?
    var messageImage: UIImage?
    var member_authority_id: Int?
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let member_authority_id = userDefault.string(forKey: MemberKey.Authority_id.rawValue)
        
        if let messageInfo = messageInfo{
            messageDetailTitleLabel.text = messageInfo.message_title
            messageDetailContentLabel.text = messageInfo.message_content
            messageDetailData.text = "\(messageInfo.coupon_start) - \(messageInfo.coupon_end)"
            print("messageEditDiscount \(messageInfo.coupon_discount)")
        }
        
        if let messageImage = messageImage {
            messageDetailImageView.image = messageImage
        }
        
        if member_authority_id == "1" {
            navigationItem.title = "優惠訊息"
            
        }
        if member_authority_id == "4" {
            messageCouponBtn.isHidden = true
            navigationItem.title = "優惠管理"
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMessageBarBtnFnc))
            
        }
    }
    
    @objc func editMessageBarBtnFnc(){
        
        userDefault.set("edit", forKey: "messageEdit")
        userDefault.synchronize()
        
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "messageEditStoryboard") as? MessageManagerViewController else{
            assertionFailure("messageEditStoryboard can't find!!")
            return
        }
        
        guard let messageEditTit = messageInfo?.message_title, let messageEditContent = messageInfo?.message_content, let messageEditStart = messageInfo?.coupon_start, let messageEditEnd = messageInfo?.coupon_end, let messageEditDiscount = messageInfo?.coupon_discount, let messageImage = messageImage, let messageID = messageInfo?.id, let messageCouponID = messageInfo?.coupon_id else {
            assertionFailure("messageEditTit fail")
            return
        }
        
        controller.messageEditTitle = messageEditTit
        controller.messageEditContent = messageEditContent
        controller.messageEditStart = messageEditStart
        controller.messageEditEnd = messageEditEnd
        controller.messageEditDiscount = "\(messageEditDiscount)"
        controller.messageEditImage = messageImage
        controller.messageID = messageID
        controller.messageCouponID = messageCouponID
        
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? MessageManagerViewController
        
        //        controller?.messageInfo = messageInfo
        
        
    }
    
}
