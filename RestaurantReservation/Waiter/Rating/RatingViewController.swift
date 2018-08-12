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
    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var ratingShowTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let member_authority_id = userDefault.string(forKey: MemberKey.Authority_id.rawValue)
        navigationItem.hidesBackButton = true
        
        ratingShowTableView.refreshControl = UIRefreshControl()
        ratingShowTableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        if member_authority_id == "1" {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose , target: self, action: #selector(newRatingBarBtnFnc))
        }
        
        if member_authority_id == "4" {
            navigationItem.title = "評分管理"
        }
    }
    
    @objc func newRatingBarBtnFnc(){
        
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ratingNewStoryBoard") else{
            assertionFailure("ratingNewStoryBoard can't find!!")
            return
        }
        navigationController?.pushViewController(controller, animated: true)
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
            
            print("output \(output)")
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let controller = segue.destination as? RatingManagerViewController
    
    }
    
}

extension RatingViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let member_authority_id = userDefault.string(forKey: MemberKey.Authority_id.rawValue)
        
        tableView.separatorStyle = .none
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ratingTableViewCell", for: indexPath) as! RatingTableViewCell
        
        let userName = array[indexPath.row].member_name
        let ratingstar = array[indexPath.row].score
        let commentUser = array[indexPath.row].comment
        let commentManager = array[indexPath.row].comment_reply
        let commentDate = array[indexPath.row].comment_time
        
        if member_authority_id == "1" {
            cell.selectionStyle = .none
        }
        
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
        
        print("array id \(array[indexPath.row].id)")
        print("array comment \(array[indexPath.row].comment)")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let commentID = array[indexPath.row].id

        ratingDelete(commendID: commentID)

        array.remove(at: indexPath.row)
        ratingShowTableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {

        let member_authority_id = userDefault.string(forKey: MemberKey.Authority_id.rawValue)
        
        if member_authority_id == "1" {
            return .none
        }
        return .delete
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let member_authority_id = userDefault.string(forKey: MemberKey.Authority_id.rawValue)
        
        if member_authority_id == "4" {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ratingResponeStoryBoard") as? RatingManagerViewController else {
                assertionFailure("messageEditStoryboard can't find!!")
                return
            }
            if let row = ratingShowTableView.indexPathForSelectedRow?.row {
                controller.ratingInfo = array[row]
                controller.commentID = array[indexPath.row].id
                
                print("commendID update1 \(array[indexPath.row].id)")
            }
            
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    func ratingDelete(commendID: Int){
        
        print("commendID \(commendID)")
        
        var json = [String: Any]()
        json["action"] = "commentDelete"
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
                showAlertController(titleText: "留言刪除異常!", messageText: "請再刪除一次", okActionText: "知道了!", printText: "優惠資訊留言刪除異常", viewController: self)
                return
            }
            
        }
    }
}

