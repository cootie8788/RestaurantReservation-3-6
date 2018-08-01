//
//  RatingViewController.swift
//  RestaurantReservation
//
//  Created by Peggy Tsai on 2018/7/24.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {
    
    let communicator = Communicator()
    var array : [RatingInfo] = []
    var comment: String?
    var member_name: String?
    var member_id: Int?
    var score: Double?
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var ratingShowTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        member_name = "hello!"
        member_id = 3
        
        ratingShowTableView.refreshControl = UIRefreshControl()
        ratingShowTableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
        ratingShowTableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中...")
    }
    
    @objc func handleRefresh(){
        getData()
        ratingShowTableView.refreshControl?.endRefreshing()
        ratingShowTableView.reloadData()
    }
    
    @IBAction func unwindRatingBack (segue: UIStoryboardSegue){
        if segue.identifier == "ratingSave"{
            guard let score = score else {
                showAlertController(titleText: "請輸入評分", messageText: "", okActionText: "知道了!", printText: "無輸入評分欄位", viewController: self)
                return
            }
            
            guard let comment = comment , !comment.isEmpty else {
                showAlertController(titleText: "請輸入評論", messageText: "", okActionText: "知道了!", printText: "無輸入評論欄位", viewController: self)
                return
            }
            
            guard let member_name = member_name else {
                assertionFailure("Rating Page get member_name fail")
                return
            }
            
            guard let member_id = member_id else {
                assertionFailure("Rating Page get member_id fail")
                return
            }
            
            ratingInsert(comment: comment, member_name: member_name, member_id: member_id , score: score)
            
        } else if segue.identifier == "ratingSave"{
            print("Back to RatingViewController")
            
        }
        
    }
    
    func getData(){
        communicator.doPost1(url: RATING_URL, ["action": "getAll"]) { (error, data) in
            guard let data = data else{
                return
            }
            
            guard let output = try? JSONDecoder().decode([RatingInfo].self, from: data) else {
                assertionFailure("get output fail")
                return
            }
            self.array = output
            self.ratingShowTableView.reloadData()
        }
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

extension RatingViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.separatorStyle = .none
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ratingTableViewCell", for: indexPath) as! RatingTableViewCell
        
        let userName = array[indexPath.row].member_name
        let ratingstar = array[indexPath.row].score
        let commentUser = array[indexPath.row].comment
        let commentManager = array[indexPath.row].comment_reply
        let commentDate = array[indexPath.row].comment_time
        
        cell.selectionStyle = .none
        cell.userNameLabel.text = userName
        cell.ratingStar.isUserInteractionEnabled = false
        cell.ratingStar.rating = ratingstar
        cell.ratingUserLabel.text = commentUser
        cell.ratingManagerLabel.text = commentManager
        cell.comentDateLabel.text = commentDate
        
        if commentManager == nil {
            cell.managerReplyLabel.isHidden = true
            cell.ratingManagerLabel.isHidden = true
            cell.commentSpaceView.isHidden = true
        }else {
            cell.managerReplyLabel.isHidden = false
            cell.ratingManagerLabel.isHidden = false
            cell.commentSpaceView.isHidden = false
        }
        return cell
    }
}

