//
//  WatiterStruct.swift
//  RestaurantReservation
//
//  Created by user on 2018/8/1.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import Foundation


struct WaiterOrder: Codable {
    var type: String?
   // var jsonCheckOrderList: String?
    var jsonCheckOrderList: [WaiterOrderMenu]
}

struct WaiterOrderMenu: Codable {
    var orderName: String = ""
    var tableName: String = ""
    var count: String = ""
    var status: String = ""
    var id: Int = -1
}

struct CallService: Codable {
    var action: String
    var listServiceMessage: [Service]
}

struct Service: Codable {
    var id: Int
    var tableNumber: String
    var time: String
}
