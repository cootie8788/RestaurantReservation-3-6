//
//  OrdertotalViewController.swift
//  RestaurantReservation
//
//  Created by 林沂諺 on 2018/8/2.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit
var newOrderTableViewControllerOrderID = -1

class OrdertotalViewController: UIViewController {
    
    @IBOutlet weak var OrderChangedSegmentControl: UISegmentedControl!
    @IBOutlet weak var orderTotalTableView: UITableView!
    var newCheckOrder = [CheckOrder]()
    let communicator =  CommunicatorOrder()
    var dateOrder = ""
    
    
    var oldCheckOrders = [OldCheckOrder]()
    var oldCheckOrder = OldCheckOrder()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderTotalTableView.delegate = self
        orderTotalTableView.dataSource = self
        
        //設定segmentedControl顏色
        let font = UIFont(name: "HelveticaNeue-Bold", size: 23.0)
        let attributes: [NSObject : AnyObject]? = [ kCTFontAttributeName : font! ]
        self.OrderChangedSegmentControl.setTitleTextAttributes(attributes, for: UIControlState.normal)
        self.OrderChangedSegmentControl.tintColor = UIColor.lightGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downNewOrder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func orderChangeSegmentControl(_ sender: UISegmentedControl) {
        switch OrderChangedSegmentControl.selectedSegmentIndex {
        case 0:
            downNewOrder()
        case 1:
            downOldOrder()
        default:
            downNewOrder()
        }
    }
    
    // 定位URL
    func downNewOrder() {
        let memberID = UserDefaults.standard.string(forKey: MemberKey.MemberID.rawValue)
        guard let memberIDInt = Int(memberID!) else {
            assertionFailure("get MemberID Fail")
            return
        }
        print("memberIDInt: \(memberIDInt.description)")
        print("orderIDappear: \(newOrderTableViewControllerOrderID)")
        let action = ActionOrder(action: "findById", memberId: memberIDInt, orderId: newOrderTableViewControllerOrderID)
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
            self.orderTotalTableView.reloadData()
            for newCheckOrder in self.newCheckOrder {
                self.dateOrder = newCheckOrder.date_order
                
            }
        }
    }
    //點餐紀錄URL
    func downOldOrder() {
        let memberID = UserDefaults.standard.string(forKey: MemberKey.MemberID.rawValue)
        guard let memberIDInt = Int(memberID!) else {
            assertionFailure("get MemberID Fail")
            return
        }
        let action = ActionOrder(action: "findDetailById", memberId: memberIDInt, orderId: 0)
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
            self.orderTotalTableView.reloadData()
            //  for orderId in self.oldCheckOrders {
            //  self.oldCheckOrder.orderId = orderId.orderId
            //
            //  }
        }
        
    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    ////        let navigationController = segue.destination as? UINavigationController
    //        let controller = segue.destination as? NewOrderDetalViewController
    //        controller?.newOrderDate = dateOrder
    //    }
    //
    
}

extension OrdertotalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if OrderChangedSegmentControl.selectedSegmentIndex == 0 {
            return newCheckOrder.count
        }else {
            return oldCheckOrders.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! OrdertotalTableViewCell
        if OrderChangedSegmentControl.selectedSegmentIndex == 0 {
            let newItem = newCheckOrder[indexPath.row]
            cell.dateLabel.text = "定位:\(newItem.date_order)"
            cell.personLabel.text = "內用人數:\(newItem.person)"
            return cell
        }else {
            let oldOrderItems = oldCheckOrders[indexPath.row]
            cell.dateLabel.text = "時間:\(oldOrderItems.date_order)"
            cell.personLabel.text = "用餐人數:\(oldOrderItems.person)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if OrderChangedSegmentControl.selectedSegmentIndex == 0 {
            //判斷Detail
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewOrderDetailVC") as? NewOrderDetalViewController
            self.navigationController?.pushViewController(controller!,animated: true)
            controller?.newOrderDate = dateOrder
        }else{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "OldOrderDetailVC") as? OldOrderDetailViewController
            self.navigationController?.pushViewController(controller!, animated: true)
            controller?.oldCheckOrderDetail2 = oldCheckOrders[indexPath.row]
        }
    }
}

extension OrdertotalViewController: UITableViewDelegate {
    
}


