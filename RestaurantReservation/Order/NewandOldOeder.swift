//
//  NewandOldOeder.swift
//  RestaurantReservation
//
//  Created by 林沂諺 on 2018/7/24.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import Foundation

//定位
struct CheckOrder: Codable {
    var orderId:Int
    var person:Int
    var time_order = ""
    var date_order = ""
}

//定位detail
struct NewCheckOrderDetal:Codable{
    var orderId:Int
    var count:Int
    var price: Int
    var name = ""
    var time_order = ""
    var date_order = ""
    
}

//點餐紀錄
struct OldCheckOrder: Codable {
    var time_order = ""
    var date_order = ""
    var person = -1
    var orderId = -1
}

//點餐紀錄detail
struct OldCheckOrderDetail: Codable {
    var orderId = -1
    var count = -1
    var price = -1
    var time_order = ""
    var date_order = ""
    var name = ""
}

//定位不點餐
struct OrderID: Codable {
    var orderId = -1
}




