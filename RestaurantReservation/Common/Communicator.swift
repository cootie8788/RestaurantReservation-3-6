//
//  Communicator.swift
//  RestaurantReservation
//
//  Created by Peggy Tsai on 2018/7/17.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import Foundation

class Communicator {
    
    typealias DataHandler = (Error?,Data?) -> Void
 
    func doPost( url : String ,data : Data, dataHandler : @escaping DataHandler){
        // 準備URL
        guard let url = URL(string: url) else {
            assertionFailure("url nil")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // POST 出去 及 取得回傳資料
        let task = URLSession.shared.uploadTask(with: request, from: data) { (output, response, error) in
            
            if let error = error {
                assertionFailure("error :\(error)")
                return
            }
            // 確認server回應狀況
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                assertionFailure("server error")
                return
            }
            // 準備要回傳的資料
            DispatchQueue.main.async {
                dataHandler(error,output)
            }
        }
        task.resume()
    }
    
    func doPost1( url : String ,_ parameters: [String: Any], dataHandler : @escaping DataHandler){
        // 準備URL
        guard let url = URL(string: url) else {
            assertionFailure("url nil")
            return
        }
        var request = URLRequest(url: url)
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // POST 出去 及 取得回傳資料
        let task = URLSession.shared.dataTask(with: request) { (output, response, error) in
            
            if let error = error {
                assertionFailure("error :\(error)")
                return
            }
            // 確認server回應狀況
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                assertionFailure("server error")
                return
            }
            // 準備要回傳的資料
            DispatchQueue.main.async {
                dataHandler(error,output)
            }
        }
        task.resume()
    }
    
}
