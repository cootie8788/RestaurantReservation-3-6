//
//  OldOrderDetailViewController.swift
//  RestaurantReservation
//
//  Created by 林沂諺 on 2018/7/25.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//
//點餐紀錄Detail
import UIKit

class OldOrderDetailViewController: UIViewController {
    
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var oldOrderDetailtableView: UITableView!
    var oldCheckOrderDetail = [OldCheckOrderDetail]()
    let communicator = CommunicatorOrder()
    var oldCheckOrderDetail2: OldCheckOrder?    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oldOrderDetailtableView.delegate = self
        oldOrderDetailtableView.dataSource = self
        let action = ActionOrder(action: "checkAllOrder", memberId: 2, orderId: (oldCheckOrderDetail2?.orderId)!)
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
            guard let output =  try? JSONDecoder().decode([OldCheckOrderDetail].self, from: result) else {
                assertionFailure("output Fail")
                return
                
            }
            self.oldCheckOrderDetail = output
            self.oldOrderDetailtableView.reloadData()
            
            guard let orderId = self.oldCheckOrderDetail2?.orderId else {
                assertionFailure("get orderId is Fail")
                return
            }
            self.orderNumberLabel.text = "\(orderId)"
            self.orderDateLabel.text = self.oldCheckOrderDetail2?.date_order
            
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //回到點餐紀錄畫面
    @IBAction func backBBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
extension OldOrderDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oldCheckOrderDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! OldDrderDetailTableViewCell
        let oldItems = oldCheckOrderDetail[indexPath.row]
        cell.foodName.text = oldItems.name
        cell.foodCount.text = "\(oldItems.count)"
        cell.foofPrice.text = "\(oldItems.price)"
        return cell
    }
}

extension OldOrderDetailViewController: UITableViewDelegate {
    
}

