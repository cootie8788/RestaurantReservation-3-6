//
//  ServiceViewController.swift
//  RestaurantReservation
//
//  Created by Jim on 2018/7/31.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var service = [Service]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        getAllService()
        
        NotificationCenter.default.addObserver(self, selector: #selector(decoderJson), name: Notification.Name.init("CallService"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func decoderJson(_ notification: Notification) {
        guard let callService = notification.userInfo?["JsonString"] as? CallService else {
            return
        }
        service = callService.listServiceMessage
        tableView.reloadData()
        print("callservice: \(callService)")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceTableViewCell
        cell.serviceLabel.text = "\(service[indexPath.row].tableNumber) time: \(service[indexPath.row].time)"
        return cell
    }

    func getAllService() {
        var getAllService = [String:Any]()
        getAllService["action"] = "getAllService"
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: getAllService), let jsonString = String(data: jsonData, encoding: .utf8) else {
            assertionFailure("toString fail!")
            return
        }
        commonWebSocketClient?.sendMessage(jsonString)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var deleteService = [String: Any]()
        deleteService["action"] = "deleteService"
        deleteService["serviceId"] = service[indexPath.row].id
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: deleteService), let jsonString = String(data: jsonData, encoding: .utf8) else {
            assertionFailure("toString fail!")
            return
        }
        
        commonWebSocketClient?.sendMessage(jsonString)
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

