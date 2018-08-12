//
//  WaiterViewController.swift
//  RestaurantReservation
//
//  Created by Jim on 2018/7/31.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

var ordertest: String?

class WaiterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var waiterOrderMenu = [WaiterOrderMenu]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ordertest != nil , ordertest != ""{
            decodeFirst(ordertest!)
        }
        ordertest = nil
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(decoderJson), name: Notification.Name.init("GetMessage"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func decodeFirst(_ jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else {
            assertionFailure("data is nil")
            return
        }
        let decoder = JSONDecoder()
        guard let orderData = try? decoder.decode(WaiterOrder.self, from: data) else {
//            assertionFailure("decoder is fail!")
            return
        }
        print("\(orderData)")
        waiterOrderMenu = orderData.jsonCheckOrderList
        tableView.reloadData()
        
    }
    
    @objc
    func decoderJson(_ notification: Notification) {
        guard let jsonString = notification.userInfo?["JsonString"] as? String else {
            return
        }
        decodeFirst(jsonString)
        print(jsonString)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waiterOrderMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaiterCell", for: indexPath) as? WaiterTableViewCell
        cell?.waiterLabel?.text = "\(waiterOrderMenu[indexPath.row].orderName)"
        cell?.tableLabel.text = "桌號：\(waiterOrderMenu[indexPath.row].tableName)"
        cell?.countLabel.text = "數量：\(waiterOrderMenu[indexPath.row].count)"
        cell?.statusLabel.text = "\(waiterOrderMenu[indexPath.row].status)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var deleteOrder = [String: Any]()
        deleteOrder["action"] = "deleteOrder"
        deleteOrder["waiterOrderMenu"] = waiterOrderMenu[indexPath.row].id
        
        print("\(deleteOrder)")
        
        let json = try? JSONSerialization.data(withJSONObject: deleteOrder)
//        let encoder = JSONEncoder()
//        let string = try? encoder.encode(waiterOrderMenu[indexPath.row])
        let abc = String(data: json!, encoding: .utf8)
        
        let alertController = UIAlertController(title: "提示", message: "確定已出餐？", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "確定", style: .default) { (alert) in
            commonWebSocketClient?.sendMessage("\(abc!)")
        }
        let actionCancel = UIAlertAction(title: "取消", style: .cancel)
        alertController.addAction(actionOK)
        alertController.addAction(actionCancel)
        // present會延遲需寫這行來取消選取並把動畫設為false
        tableView.deselectRow(at: indexPath, animated: false)
        self.present(alertController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
