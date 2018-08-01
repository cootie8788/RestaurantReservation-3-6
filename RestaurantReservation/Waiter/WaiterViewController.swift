//
//  WaiterViewController.swift
//  RestaurantReservation
//
//  Created by Jim on 2018/7/31.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit
import Starscream

class WaiterViewController: UIViewController,WebSocketDelegate {
    let socket = WebSocket(url: URL(string: "http://127.0.0.1:8080/RestaurantReservationApp_Web/CheckOrderWebSocket/amy")!)

    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is websocketDidConnect")

    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is websocketDidDisconnect")

    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("websocket is websocketDidReceiveMessage")

    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocket is websocketDidReceiveData")

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("aaaaaaaa")
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        socket.delegate = self
        socket.connect()

    }
    
    @IBAction func btnCheck(_ sender: Any) {
        if socket.isConnected {
            // do cool stuff.
            print("連到")
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
