//
//  MemberStruct.swift
//  RestaurantReservation
//
//  Created by user on 2018/7/25.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import Foundation

struct Login: Codable {
    var isUserValid = false
    var authority_id = -1
    var memberId = -1
    var memberName = ""
}

struct Member: Codable {
    var id: Int
    var name = ""
    var sex: Int
    var phone = ""
    var email = ""
    var password = ""
}

struct Action: Codable {
    var action: String
    var member: Member
}

enum MemberAction: String {
    case MemberInsert = "memberInsert"
    case IsUserValid = "isUserValid"
    case GetMemberData = "getMemberData"
    case MemberUpdate = "memberUpdate"
    
}

enum MemberKey: String {
    case MemberID = "memberId"
    case TableNumber = "tableNumber"
}
