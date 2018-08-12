//
//  RatingManagerViewController.swift
//  RestaurantReservation
//
//  Created by Jim on 2018/7/31.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit
import Cosmos

class RatingManagerViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentTextField: UILabel!
    @IBOutlet weak var responeTextField: UITextField!
    let communicator = Communicator()
    var member_name: String?
    var member_id: Int?
    var commentID: Int?
    var score: Double?
    var ratingInfo: RatingInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        guard let userName = ratingInfo?.member_name else {
            assertionFailure("userName invailed")
            return
        }
        guard let ratingstar = ratingInfo?.score else {
            assertionFailure("ratingstar invailed")
            return
        }
        guard let commentUser = ratingInfo?.comment else {
            assertionFailure("commentUser invailed")
            return
        }
        
        if let commentResponse = ratingInfo?.comment_reply {
            responeTextField.text = commentResponse
        }
        
        responeTextField.delegate = self
        
        userNameLabel.text = userName
        ratingStar.isUserInteractionEnabled = false
        ratingStar.rating = ratingstar
        commentTextField.text = commentUser
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelResponseBtnFnc))

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "傳送", style: .plain, target: self, action: #selector(saveResponseBarBtnFnc))
        
        // Do any additional setup after loading the view.
    }
    
    @objc func cancelResponseBtnFnc() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ratingMainStoryBoard") else{
            assertionFailure("ratingMainStoryBoard can't find!! (cancel)")
            return
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func saveResponseBarBtnFnc() {
        
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ratingMainStoryBoard") else{
            assertionFailure("ratingMainStoryBoard can't find!! (save Response)")
            return
        }
        
        guard let comment = responeTextField.text , !comment.isEmpty else {
            showAlertController(titleText: "請輸入回應評論", messageText: "", okActionText: "知道了!", printText: "無輸入評論欄位", viewController: self)
            return
        }
        
        guard let commentID = commentID else {
            assertionFailure("commentID invaild!!")
            return
        }
        
        ratingUpdateReply(commentReply: comment, commendID: commentID)
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func ratingUpdateReply(commentReply: String, commendID: Int){
        
        print("commendID update \(commendID)")
        
        var json = [String: Any]()
        json["action"] = "updateReply"
        json["comment_reply"] = commentReply
        json["commend_id"] = commendID
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        communicator.doPost(url: RATING_URL, data: jsonData!) { (error, data) in
            guard let data = data else{
                return
            }
            
            //output字串 data 轉 string
            let respone = String(data: data, encoding: String.Encoding.utf8)
            //檢查是否成功
            if respone != "1" {
                showAlertController(titleText: "留言回應異常!", messageText: "請再刪除一次", okActionText: "知道了!", printText: "留言回應異常", viewController: self)
                return
            }
        }
    }
    
    func scoreSaveFunction(rating: Double){
        score = rating
    }

    // 點return就收鍵盤
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 點背景收鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

