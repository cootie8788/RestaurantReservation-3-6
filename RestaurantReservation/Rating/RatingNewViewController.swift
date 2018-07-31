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
    var comment: String?
    var member_name: String?
    var member_id: Int?
    var score: Double?
    
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingStar.settings.minTouchRating = 0
        
        member_name = "hello!"
        member_id = 1
        
        userNameLabel.text = member_name
        ratingStar.didFinishTouchingCosmos = scoreSaveFunction
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        comment = commentTextField.text
        let controller = segue.destination as? RatingViewController
        controller?.comment = comment
        controller?.score = score
        
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
}
