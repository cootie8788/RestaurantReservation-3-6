//
//  NewOrderDetalViewController.swift
//  RestaurantReservation
//
//  Created by 林沂諺 on 2018/7/25.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit
//定位畫面detail
class NewOrderDetalViewController: UIViewController {
    
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var newOrderDetailtableView: UITableView!
    var newCheckOrderDetail = [NewCheckOrderDetal]()
    let communicator = CommunicatorOrder()
    var orderNumber = -1
    var orderDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newOrderDetailtableView.delegate = self
        newOrderDetailtableView.dataSource = self
        let action = ActionOrder(action: "checkOrderGet", memberId: 2, orderId: 249)
        let econder = JSONEncoder()
        econder.outputFormatting = .init()
        guard let uploadData = try? econder.encode(action) else {
            assertionFailure("Data Fail")
            return
        }
        communicator.doPost(url: ORDER_URL, data: uploadData) { (error, result) in
            guard let result = result else {
                assertionFailure("get result Fail")
                
                return
            }
            guard let output =  try? JSONDecoder().decode([NewCheckOrderDetal].self, from: result) else {
                assertionFailure("output Fail")
                return
                
            }
            self.newCheckOrderDetail = output
            for newCheckOrder in self.newCheckOrderDetail  {
                self.orderNumber = newCheckOrder.orderId
                self.orderDate = newCheckOrder.date_order
            }
            self.newOrderDetailtableView.reloadData()
            self.orderNumberLabel.text = "\(self.orderNumber)"
            self.orderDateLabel.text = self.orderDate
        }
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
extension NewOrderDetalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newCheckOrderDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NewOrderDetailTableViewCell
        let newItems = newCheckOrderDetail[indexPath.row]
        cell.foodItems.text = newItems.name
        cell.quantity.text = "\(newItems.count)"
        cell.price.text = "\(newItems.price)"
        return cell
        
    }
}
extension NewOrderDetalViewController: UITableViewDelegate {
  
    
}
