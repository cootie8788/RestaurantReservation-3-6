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
    var jsonCheckOrderList: String?
    
}

struct WaiterOrderMenu: Codable {
    var orderName: String?
    var tableName: String?
    var count: String?
    var status: String?
}

struct aaabbb: Codable {
    var aaa: [WaiterOrderMenu]
}
