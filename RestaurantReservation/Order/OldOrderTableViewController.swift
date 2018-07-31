//
//  OldOrderTableViewController.swift
//  RestaurantReservation
//
//  Created by 林沂諺 on 2018/7/23.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//
//點餐紀錄Controller
import UIKit

class OldOrderTableViewController: UITableViewController {
    
    let communicator =  CommunicatorOrder()
    var oldCheckOrders = [OldCheckOrder]()
    var oldCheckOrder = OldCheckOrder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let action = ActionOrder(action: "findDetailById", memberId: 2, orderId: 0)
        let econder = JSONEncoder()
        econder.outputFormatting = .init()
        
        guard let uploadData = try? econder.encode(action) else {
            assertionFailure("JSON encode Fail")
            return
        }
        communicator.doPost(url: ORDER_URL, data: uploadData) { (error, result) in
            if let error = error  {
                print("\(error)")
                return
            }
            guard let result = result else{
                assertionFailure("get data fail")
                return
            }
            
            guard let output = try? JSONDecoder().decode([OldCheckOrder].self, from: result) else {
                assertionFailure("get output fail")
                return
            }
            self.oldCheckOrders = output
            self.tableView.reloadData()
            //  for orderId in self.oldCheckOrders {
            //  self.oldCheckOrder.orderId = orderId.orderId
            //
            //  }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return oldCheckOrders.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let oldOrderItems = oldCheckOrders[indexPath.row]
        cell.textLabel?.text = "時間:\(oldOrderItems.date_order)"
        cell.detailTextLabel?.text = "用餐人數:\(oldOrderItems.person)"
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // prepare將資料帶回點餐紀錄資料:中間有NavigationController 傳遞資料做法 要拉線
        let navation = segue.destination as? UINavigationController
        let controller = navation?.viewControllers.first as? OldOrderDetailViewController
        let indexPath = tableView.indexPathForSelectedRow
        controller?.oldCheckOrderDetail2 = oldCheckOrders[(indexPath?.row)!]
    }
}

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //present 傳遞資料:中間有NavigationController 傳遞資料做法 不用拉線
//        let navation = storyboard?.instantiateViewController(withIdentifier: "OldOrderNavigation") as? UINavigationController
//        let controller = navation?.viewControllers.first as? OldOrderDetailViewController
//        controller?.oldCheckOrderDetail2 = oldCheckOrders[indexPath.row]
//        present(navation!, animated: true)
//    }
