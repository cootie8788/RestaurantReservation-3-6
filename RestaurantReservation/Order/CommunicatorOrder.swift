//
//  CommunicatorOrder.swift
//  RestaurantReservation
//
//  Created by 林沂諺 on 2018/7/24.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import Foundation
class CommunicatorOrder  {
    
    typealias doneHandler = (Error?, Data?) -> Void
    
    func doPost(url: String , data: Data, doneHandler: @escaping doneHandler ) {
        guard let url = URL(string: url) else {
            assertionFailure("url nil")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application", forHTTPHeaderField: "Content")
    
        
        let task = URLSession.shared.uploadTask(with: request, from: data) { (output, response, error) in
            
            if let error = error {
                assertionFailure("error:\(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                assertionFailure("server error")
                return
            }
            print("\(response)")
            DispatchQueue.main.async {
                doneHandler(error,output)
            }
        }
        task.resume()
    }
    
}
