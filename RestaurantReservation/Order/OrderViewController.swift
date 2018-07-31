//
//  OrderViewController.swift
//  RestaurantReservation
//
//  Created by Peggy Tsai on 2018/7/13.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {

    
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var ordersegmentedControl: UISegmentedControl!
    
    let newOrderVC = UIStoryboard(name: "Order", bundle: nil).instantiateViewController(withIdentifier: "NewOrderVC")
    let oldOrderVC = UIStoryboard(name: "Order", bundle: nil).instantiateViewController(withIdentifier: "OldOrderVC")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定segmentedControl顏色
        let font = UIFont(name: "HelveticaNeue-Bold", size: 23.0)
        let attributes: [NSObject : AnyObject]? = [ kCTFontAttributeName : font! ]
        self.ordersegmentedControl.setTitleTextAttributes(attributes, for: UIControlState.normal)
        self.ordersegmentedControl.tintColor = UIColor.lightGray
        
        //預設一開始為定位畫面
        orderView.addSubview(newOrderVC.view)
        ordersegmentedControl.selectedSegmentIndex = 0
        ordersegmentedControl.isHidden = false
    }
    
    //定位畫面與點餐畫面切換
    @IBAction func orderindexChanged(_ sender: UISegmentedControl) {
        switch ordersegmentedControl.selectedSegmentIndex {
        case 0 :
            orderView.addSubview(newOrderVC.view)//定位畫面
        case 1 :
            orderView.addSubview(oldOrderVC.view)//點餐紀錄
        default:
            orderView.addSubview(newOrderVC.view)
        }
    }
    //  返回定位畫面
    @IBAction func goBack(segue: UIStoryboardSegue) {
        
    }
    // 返回紀錄畫面
    @IBAction func goback2(segue: UIStoryboardSegue) {
        ordersegmentedControl.selectedSegmentIndex = 1
    }

}
