//
//  Common.swift
//  RestaurantReservation
//
//  Created by Peggy Tsai on 2018/7/17.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import Foundation
import UIKit

//let HOST_URL = "http://localhost:8080/RestaurantReservationApp_Web"
//let HOST_URL = "http://192.168.50.45:8080/RestaurantReservationApp_Web"
let HOST_URL = "http://192.168.50.65:8080/RestaurantReservationApp_Web"
let CHECK_ORDER_URL = HOST_URL + "/CheckOrderServlet"
let MENU_URL = HOST_URL + "/MenuServlet"
let MESSAGE_URL = HOST_URL + "/MessageServlet"
let RATING_URL = HOST_URL + "/RatingServlet"
let MEMBER_URL = HOST_URL + "/MemberServlet"


//let SocketUrl = "ws://127.0.0.1:8080/RestaurantReservationApp_Web/CheckOrderWebSocket/"
//let GET_DOG_INFO = "getDogInfo"

func showAlertController (titleText: String, messageText: String, okActionText: String, printText: String, viewController: UIViewController ){
    let alertController = UIAlertController(
        title: "\(titleText)",message: "\(messageText)",preferredStyle: .alert)
    
    // 建立[確認]按鈕
    let okAction = UIAlertAction(
        title: "\(okActionText)",style: .default,
        handler: {
            (action: UIAlertAction!) -> Void in print("\(printText)")
    })
    
    alertController.addAction(okAction)
    
    // 顯示提示框
    viewController.present(alertController, animated: true, completion: nil)
    return
}
