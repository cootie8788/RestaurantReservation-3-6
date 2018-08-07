//
//  MessageViewController.swift
//  RestaurantReservation
//
//  Created by Peggy Tsai on 2018/7/13.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    let communicator = Communicator()
    var array: [MessageInfo] = []
    var array_img: [UIImage] = []
    var arrayimageId = [ImageId]()
    var member_name: String?
    var member_authority_id: Int?
    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var messageShowTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getData()
        let member_authority_id = userDefault.string(forKey: MemberKey.Authority_id.rawValue)
        navigationItem.hidesBackButton = true
        
        messageShowTableView.refreshControl = UIRefreshControl()
        messageShowTableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        if member_authority_id == "1" {
            navigationItem.title = "優惠訊息"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage (named: "icon-ring"), style: .plain, target: nil, action: nil)

        }
            
        if member_authority_id == "4" {
            navigationItem.title = "優惠管理"
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose , target: self, action: #selector(newMessageBarBtnFnc))
            
        }
    }

    @objc func newMessageBarBtnFnc(){
        userDefault.set("new", forKey: "messageEdit")
        userDefault.synchronize()
        
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "messageEditStoryboard") else{
            assertionFailure("messageEditStoryboard can't find!!")
            return
        }
        navigationController?.pushViewController(controller, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        getData()
        messageShowTableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中...")
    }
    
    @objc func handleRefresh(){
        array = []
        array_img = []
        getData()
        messageShowTableView.reloadData()
        messageShowTableView.refreshControl?.endRefreshing()
        
    }
    
    func getData(){
        communicator.doPost1(url: MESSAGE_URL, ["action": "getAll"]) { (error, data) in
            guard let data = data else{
                return
            }
            
            guard let output = try? JSONDecoder().decode([MessageInfo].self, from: data) else {
                assertionFailure("get output fail")
                return
            }
            
//            print("array.count: \(self.array.count)")
            self.array = output
            self.getImage()
        }
    }
    
    func getImage(){
        for x in 0..<self.array.count {
            let id = self.array[x].id
//            print("array[x].id: \(id)")
            communicator.doPost1(url: MESSAGE_URL, ["action": "getImage", "id": id , "imageSize": 375]) { (error, data) in
                guard let data = data else{
                    return
                }
                let imageId = ImageId(id: id, image: UIImage(data: data)!)
                self.arrayimageId.append(imageId)
                if let image = UIImage(data: data) {
                    self.array_img.append(image)
                    self.messageShowTableView.reloadData()
                }
                if self.arrayimageId.count == self.array.count{
                    self.arrayimageId = self.arrayimageId.sorted(by: { (a, b) -> Bool in
                        a.id > b.id
                    })
                    print("\(self.arrayimageId)")
                    self.messageShowTableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? MessageDetailViewController
        
        if let row = messageShowTableView.indexPathForSelectedRow?.row {
            controller?.messageInfo = array[row]
            controller?.messageImage = arrayimageId[row].image
        }
    }
    
}

extension MessageViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageTableViewCell", for: indexPath) as! MessageTableViewCell
        let messageContent = array[indexPath.row].message_content
        if array_img.count == array.count{
//            print("Array Image Count : \(array_img.count),IndexPathRow : \(indexPath.row)")
            let messageImage = arrayimageId[indexPath.row].image
            cell.messageImageView.image = messageImage
        }
        cell.messageContentLabel.text = messageContent
        return cell
    }
    
}
