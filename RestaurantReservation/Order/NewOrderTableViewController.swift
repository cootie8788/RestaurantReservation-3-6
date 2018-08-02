//
//  NewOrderTableViewController.swift
//  RestaurantReservation
//
//  Created by 林沂諺 on 2018/7/23.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//
//定位畫面Controller
import UIKit

var newOrderTableViewControllerOrderID = -1

class NewOrderTableViewController: UITableViewController {
    
    var newCheckOrder = [CheckOrder]()
    let communicator =  CommunicatorOrder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        print("ggggggggg\(newOrderTableViewControllerOrderID)")
        let action = ActionOrder(action: "findById", memberId: 3, orderId: newOrderTableViewControllerOrderID)
        let econder = JSONEncoder()
        econder.outputFormatting = .init()
        guard let uploadData = try? econder.encode(action) else {
            assertionFailure("JSON encode Fail")
            return
        }
        
        communicator.doPost(url: ORDER_URL, data: uploadData) { (error, result) in
            guard let result = result else {
                assertionFailure("get data fail")
                return
            }
            guard let output = try? JSONDecoder().decode([CheckOrder].self, from: result) else {
                assertionFailure("get output fail")
                return
            }
            self.newCheckOrder = output
            self.tableView.reloadData()
        }
    }
    // for 迴圈寫法
    //            for newOutput in output {
    //                self.newCheckOrder.append(newOutput)
    //            }
    //            print("newOutPut\(self.newCheckOrder)")
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newCheckOrder.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let newItem = newCheckOrder[indexPath.row]
        cell.textLabel?.text = "定位:\(newItem.date_order)"
        cell.detailTextLabel?.text = "內用人數:\(newItem.person)"
        return cell
    }
    
    //     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //     }
    
}
