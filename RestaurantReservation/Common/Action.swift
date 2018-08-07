//
//  Action.swift
//  RestaurantReservation
//
//  Created by Peggy Tsai on 2018/7/24.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import Foundation
import UIKit

struct RatingInfo: Codable {
    var id: Int
    var comment: String
    var comment_time: String
    var member_name: String
    var member_id: Int
    var score: Double
    var comment_reply: String?
}

struct MessageInfo: Codable {
    var id: Int
    var message_title: String
    var message_content: String
    var coupon_id: Int
    var coupon_discount: Double
    var coupon_start: String
    var coupon_end: String
    
}

struct ActionOrder: Codable {
    var action: String?
    var memberId: Int
    var orderId: Int
}

struct dateInfo: Codable {
    var action: String?
    var date: String?
    var person: String?
    var memberId: Int
}

struct ImageId {
    var id: Int
    var image: UIImage
    
}

