//
//  WebSocket.swift
//  RestaurantReservation
//
//  Created by user on 2018/8/1.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import Foundation
import Starscream

class CommonWebSocketClient: WebSocketDelegate {
    var url: URL
    var socket: WebSocketClient
    init(url: String) {
        let encodedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        self.url = URL(string: encodedString!)!
        self.socket = WebSocket(url: self.url)
    }
    
    func startWebSocket() {
        socket.delegate = self
        socket.connect()
    }
    
    func stopWebSocket() {
        socket.disconnect()
//        socket.delegate = nil
    }
    
    func sendMessage(_ message: String) {
        socket.write(string: message)
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocketDidConnect")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect")
        socket.delegate = nil
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("websocketDidReceiveMessage: \(text)")
        
        if ordertest != nil {
            ordertest = text
        }
        
        // 解析服務鈴
        guard let data = text.data(using: .utf8) else {
            assertionFailure("data is nil")
            return
        }
        let decoder = JSONDecoder()
        if let callService = try? decoder.decode(CallService.self, from: data) {
            NotificationCenter.default.post(name: Notification.Name.init("CallService"), object: nil, userInfo: ["JsonString": callService])
        } else {
            NotificationCenter.default.post(name: Notification.Name.init("GetMessage"), object: nil, userInfo: ["JsonString": text])
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
       print("websocketDidReceiveData")
    }
   
}

