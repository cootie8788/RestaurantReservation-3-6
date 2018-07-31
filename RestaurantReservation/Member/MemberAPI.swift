//
//  MemberAPI.swift
//  RestaurantReservation
//
//  Created by user on 2018/7/25.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import Foundation

class MemberAPI {
    
    typealias DataHandler = (Error? , Data?) -> Void
    
    func doPost(url: String, data: Data, dataHandler: @escaping DataHandler) {
        
        guard let url = URL(string: url) else {
            let error = NSError(domain: "URL Error", code: -1, userInfo: nil)
            OperationQueue.main.addOperation {
                dataHandler(error, nil)
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.uploadTask(with: request, from: data) { (data, response, error) in
            
            if let error = error {
                OperationQueue.main.addOperation {
                    dataHandler(error,nil)
                }
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else{
                let error = NSError(domain: "Server Error", code: -1, userInfo: nil)
                OperationQueue.main.addOperation {
                    dataHandler(error,nil)
                }
                return
            }
            OperationQueue.main.addOperation {
                dataHandler(nil,data)
            }
        }
        task.resume()
    }
}
