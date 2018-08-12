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
    
    let communicator = Communicator()
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

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let controller = segue.destination as? MessageManagerViewController
//    }
    
    @IBAction func messageCouponBtnPress(_ sender: Any) {
        
        guard let member_ID = userDefault.string(forKey: MemberKey.MemberID.rawValue) else {
            assertionFailure("member_authority_id is empty (coupon)")
            return
        }
        
        guard let CouponID = messageInfo?.coupon_id, let memberID = Int(member_ID) else {
            assertionFailure("CouponID memberID is empty")
            return
        }
        print("memberID \(memberID) CouponID \(CouponID)")
        getCoupon(memberID: memberID, CouponID: CouponID)
        
    }
    
    
    func getCoupon(memberID: Int,CouponID: Int){
        var json = [String: Any]()
        json["action"] = "couponInsert"
        json["couponID"] = CouponID
        json["memberID"] = memberID
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        communicator.doPost(url: MESSAGE_URL, data: jsonData!) { (error, data) in
            guard let data = data else{
                return
            }
            
            //output字串 data 轉 string
            let respone = String(data: data, encoding: String.Encoding.utf8)
            //檢查是否成功
            if respone == "1" {
                showAlertController(titleText: "成功領取折價卷!", messageText: "", okActionText: "知道了!", printText: "成功領取優惠券", viewController: self)
                return
            }
            
            if respone != "1" {
                showAlertController(titleText: "領取折價卷失敗!", messageText: "請再領取一次", okActionText: "知道了!", printText: "領舉優惠卷異常", viewController: self)
                return
            }
            
        }
    }
}
