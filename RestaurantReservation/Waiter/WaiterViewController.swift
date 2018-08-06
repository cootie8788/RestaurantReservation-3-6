//
//  WaiterViewController.swift
//  RestaurantReservation
//
//  Created by Jim on 2018/7/31.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit
//import Starscream
var ordertest: String?

class WaiterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var waiterOrderMenu = [WaiterOrderMenu]()
    
    @IBOutlet weak var tableView: UITableView!
    //    let socket = WebSocket(url: URL(string: "http://127.0.0.1:8080/RestaurantReservationApp_Web/CheckOrderWebSocket/amy")!)
//
//    var waiterOrder = WaiterOrder()
//
//    func websocketDidConnect(socket: WebSocketClient) {
//        print("websocket is websocketDidConnect")
//
//    }
//
//    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
//        print("websocket is websocketDidDisconnect")
//
//    }
//
//    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        print("websocket is websocketDidReceiveMessage")
//        print(text)
//        guard let data = text.data(using: .utf8) else {
//            assertionFailure("data is nil")
//            return
//        }
//        let decoder = JSONDecoder()
//        guard let orderData = try? decoder.decode(WaiterOrder.self, from: data) else {
//            assertionFailure("decoder is fail!")
//            return
//        }
//        print("\(orderData)")
//
//        let jsonData = orderData.jsonCheckOrderList?.data(using: .utf8)
//        print("\(jsonData)")
//        guard let ac = try? decoder.decode([WaiterOrderMenu].self, from: jsonData!) else {
//            return
//        }
//        print("\(ac)")
//
//
//    }
//
//    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
//        print("websocket is websocketDidReceiveData")
//
//    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {

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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waiterOrderMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaiterCell", for: indexPath) as? WaiterTableViewCell
        cell?.waiterLabel?.text = "\(waiterOrderMenu[indexPath.row].orderName) 第\(waiterOrderMenu[indexPath.row].tableName)桌  數量：\(waiterOrderMenu[indexPath.row].count) 狀態：\(waiterOrderMenu[indexPath.row].status)"
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
        self.present(alertController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPressed(_ sender: Any) {
//        socket.delegate = self
//        socket.connect()

    }
    
    @IBAction func btnCheck(_ sender: Any) {
//        if socket.isConnected {
//            // do cool stuff.
//            print("連到")
//        }
//        socket.disconnect()
//        let json = JSONEncoder()
//        let abc = ["aaa":123]
//        let jsonEncoder = try? json.encode(abc)
//        socket.write(data: jsonEncoder!)
        commonWebSocketClient?.stopWebSocket()

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
