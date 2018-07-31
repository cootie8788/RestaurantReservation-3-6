//
//  LoginAPI.swift
//  RestaurantReservation
//
//  Created by user on 2018/7/22.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import Foundation

typealias APIHandler = (Error?, Login?) -> Void
typealias handler = (Error?, Int?) -> Void
class LoginAPI {
    let targerURL: URL
    init(url: URL) {
        targerURL = url
    }
    func isUserValid(email: String, password: String, apiHandler: @escaping APIHandler) {
        
        let json: [String: Any] = ["action": "isUserValid", "email": email, "password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        var request = URLRequest(url: targerURL)
        request.httpMethod = "POST"
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("\(error)")
                OperationQueue.main.addOperation {
                    apiHandler(error,nil)
                }
                return

            }
            guard let data = data else {
                print("data is nil")
                let error = NSError(domain: "Data is nil", code: -1, userInfo: nil)
                OperationQueue.main.addOperation{
                    apiHandler(error,nil)
                }
                return
            }
            let decoder = JSONDecoder()
            let responseJSON = try? decoder.decode(Login.self, from: data)
            if let result = responseJSON {
                OperationQueue.main.addOperation{
                    apiHandler(nil,result)
                }
            } else {
                let error = NSError(domain: "Parse JSON Fail!", code: -1, userInfo: nil)
                OperationQueue.main.addOperation {
                    apiHandler(error,nil)
                }
            }
//            print("\(responseJSON)")
//            let responseJSON = try? JSONSerialization.jsonObject(with: data)
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
//            }
        }
        task.resume()
        
    }
    
    func memberInsert(name: String, sex: String, phone: String, email: String, password: String, handler: @escaping handler) {
        
        let member = Member(id: 0, name: name, sex: 1, phone: phone, email: email, password: password)
        
        let endocer = JSONEncoder()
        guard let memberJson = try? endocer.encode(member) else {
            return
        }
        let memberString = String(data: memberJson, encoding: .utf8)
//        var json: [String: Any] = ["action": "memberInsert", "member": memberString]
        
        var json = [String:Any]()
        json["action"] = "memberInsert"
        json["member"] = memberString
        
        let memberJSON = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: targerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: memberJSON) { (data, response, error) in
            if let error = error {
                print("\(error)")
                OperationQueue.main.addOperation {
                    handler(error,nil)
                }
                return
                
            }
            guard let data = data else {
                print("data is nil")
                let error = NSError(domain: "Data is nil", code: -1, userInfo: nil)
                OperationQueue.main.addOperation{
                    handler(error,nil)
                }
                return
            }
            print(data)
            let decoder = JSONDecoder()
            let responseJSON = try? decoder.decode(Int.self, from: data)
            let responseString = String(data: data, encoding: .utf8)
            print(responseString)
            if let result = responseJSON {
                OperationQueue.main.addOperation{
                    handler(nil,result)
                }
            } else {
                let error = NSError(domain: "Parse JSON Fail!", code: -1, userInfo: nil)
                OperationQueue.main.addOperation {
                    handler(error,nil)
                }
            }
            //            print("\(responseJSON)")
            //            let responseJSON = try? JSONSerialization.jsonObject(with: data)
            //            if let responseJSON = responseJSON as? [String: Any] {
            //                print(responseJSON)
            //            }
        }
        task.resume()
    }
}
//typealias DownloadAPIHandler = (Error?, ExangeRateInfo?) -> Void
//
//class DownloadAPI {
//    let targerURL: URL
//    init(downloadAPIUrl: URL) {
//        targerURL = downloadAPIUrl
//    }
//
//    func download(downloadHandler: @escaping DownloadAPIHandler) {
//
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//        let task = session.dataTask(with: targerURL) { (data, response, error) in
//
//            if let error = error {
//                print("Download Fail:  \(error)")
//                OperationQueue.main.addOperation {
//                    downloadHandler(error,nil)
//                    return
//                }
//            }
//
//            guard let data = data else {
//                print("Data is nil")
//                let error = NSError(domain: "Data is nil", code: -1, userInfo: nil)
//                OperationQueue.main.addOperation {
//                    downloadHandler(error,nil)
//                }
//                return
//            }
//
//            let decoder = JSONDecoder()
//            let result = try? decoder.decode(ExangeRateInfo.self, from: data)
//            if let result = result {
//                OperationQueue.main.addOperation {
//                    downloadHandler(nil,result)
//                }
//            }else {
//                let error = NSError(domain: "Parse JSON Fail!", code: -1, userInfo: nil)
//                OperationQueue.main.addOperation {
//                    downloadHandler(error,nil)
//                }
//            }
//        }
//        task.resume()
//}
