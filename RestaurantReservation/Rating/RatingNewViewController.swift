//
//  RatingNewViewController.swift
//  RestaurantReservation
//
//  Created by Peggy Tsai on 2018/7/25.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit
import Cosmos

class RatingNewViewController: UIViewController {
    
    var controller: RatingViewController?
    let communicator = Communicator()
    var member_name: String?
    var member_id: Int?
    var score: Double?
    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingStar.settings.minTouchRating = 0
        
        let member_name = userDefault.string(forKey: MemberKey.MemberName.rawValue)
        
        userNameLabel.text = member_name
        ratingStar.didFinishTouchingCosmos = scoreSaveFunction
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelBarBtnFnc))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "傳送", style: .plain, target: self, action: #selector(saveBarBtnFnc))
        
    }
    
    @objc func cancelBarBtnFnc(){
        
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ratingMainStoryBoard") else{
            assertionFailure("ratingMainStoryBoard can't find!! (cancel)")
            return
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func saveBarBtnFnc(){
        
        
        let memberName = userDefault.string(forKey: MemberKey.MemberName.rawValue)
        let memberID = userDefault.string(forKey: MemberKey.MemberID.rawValue)
        
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ratingMainStoryBoard") else{
            assertionFailure("ratingMainStoryBoard can't find!! (save)")
            return
        }
        
        guard let score = score else {
            showAlertController(titleText: "請輸入評分", messageText: "", okActionText: "知道了!", printText: "無輸入評分欄位", viewController: self)
            return
        }
        
        guard let comment = commentTextField.text , !comment.isEmpty else {
            showAlertController(titleText: "請輸入評論", messageText: "", okActionText: "知道了!", printText: "無輸入評論欄位", viewController: self)
            return
        }
        
        guard let member_name = memberName else {
            assertionFailure("Rating Page get member_name fail")
            return
        }
        
        guard let memberId = memberID, let member_id = Int(memberId) else {
            assertionFailure("Rating Page get member_id fail")
            return
        }
        
        ratingInsert(comment: comment, member_name: member_name, member_id: member_id , score: score)
        
        navigationController?.pushViewController(controller, animated: true)
    }

    func scoreSaveFunction(rating: Double){
        score = rating
    }
    
    func ratingInsert(comment: String, member_name: String, member_id: Int, score: Double ){
        
        // 準備將資料轉為JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init()
        
        let ratingInsertInfo = RatingInfo(id: 0, comment: comment, comment_time: "0" , member_name: member_name, member_id: member_id, score: score, comment_reply: nil)
        
        // 轉為JSON
        guard let encodedData = try? encoder.encode(ratingInsertInfo) else {
            assertionFailure("JSON encode Fail")
            return
        }
        
        let jsonstring = String(data: encodedData, encoding: .utf8)
        var parameters = ["action": "ratingInsert"]
        parameters["rating"] = jsonstring

        // 送資料 and 解析回傳的JSON資料
        communicator.doPost1(url: RATING_URL, parameters) { (error, data) in
            
            guard let data = data else{
                return
            }
            
            //output字串 data 轉 string
            let respone = String(data: data, encoding: String.Encoding.utf8)
            //檢查是否成功
            if respone != "1" {
                showAlertController(titleText: "評分異常!", messageText: "請再傳送一次", okActionText: "知道了!", printText: "評分異常", viewController: self)
            }
        }
    }
    
    // 點背景收鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
