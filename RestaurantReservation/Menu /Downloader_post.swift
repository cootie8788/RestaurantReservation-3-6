

import UIKit


typealias DoneHandler = (_ error:Error?, _ result:Any?) ->Void
//typealias DoneHandler = (_ error:Error?,_ result:[String: Any]?) ->Void
//通用                        //回傳 字典（因為三方外掛會幫弄好成字典）
typealias DownloadDoneHandler = (_ error:Error?,_ result:Data) ->Void


typealias Handler = (_ control:UITableViewController?, _ error:Error?,_ result:Data) ->Void






class Downloader {
    
//    static let BASEURL = "http://localhost:8080/RestaurantReservationApp_Web"
    static let BASEURL = HOST_URL
    
    let Menu_URL = BASEURL + "/MenuServlet"
    let CheckOrder_URL = BASEURL + "/CheckOrderServlet"
    
    let UpdateStock_URL = BASEURL + "/updateStock/{member_id}"
    let Message_URL = BASEURL + "/MessageServlet"
    
    
    static let shared = Downloader()
    let encoder = JSONEncoder()
    
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    private init(){
        
    }
    
    
    

    func test(_ control:UITableViewController?,doneHandler: @escaping Handler) {
        
        let parameters  = ["action": "getAll"] as [String: Any]
        //這個函數錯了 #function
        //行數在裡面 顯示 #line
        doPost_menuList(funcName: #function, control,Menu_URL, parameters, doneHandler: doneHandler)
    }
    
   
    func orderInsert(fileName:NSString ,
                     total_money:String ,
                     memberID:String,
                     cart:[OrderMenu],
                     person:String,
                     data:String,  doneHandler: @escaping DownloadDoneHandler) {
        
        let encoder: JSONEncoder = JSONEncoder()
        let encoded = try? encoder.encode(cart)
        let jsonString = String(data: encoded!, encoding: .utf8)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
//        let stringTime = dateFormatter.string(from: data)
        
        let parameters = ["action": "orderInsert",
                          "total_money":total_money,
                          "memberID":memberID,
                          "cart":jsonString,
                          "person":person,
                          "data":data]
        
        
        doPost(dic: [0:fileName,1:#function],CheckOrder_URL, parameters , doneHandler: doneHandler)
    }
    
    func orderInsert(fileName:NSString ,
                     total_money:String ,
                     memberID:String,
                     cart:[OrderMenu],
                     table_member:String, doneHandler: @escaping DownloadDoneHandler) {
        
        let encoder: JSONEncoder = JSONEncoder()
        let encoded = try? encoder.encode(cart)
        let jsonString = String(data: encoded!, encoding: .utf8)
        
        let parameters = ["action": "orderInsert",
                          "total_money":total_money,
                          "memberID":memberID,
                          "cart":jsonString,
                          "table_member":table_member]
        
        
        doPost(dic: [0:fileName,1:#function],CheckOrder_URL, parameters , doneHandler: doneHandler)
    }
    
    func getlist(fileName:NSString ,doneHandler: @escaping DownloadDoneHandler) {
        
        let parameters  = ["action": "getAll"] as [String: Any]
        
        doPost(dic: [0:fileName,1:#function],Menu_URL, parameters, doneHandler: doneHandler)
    }
    
    
    func menuUpdata(fileName:NSString ,_ menu:Menu , doneHandler:  DownloadDoneHandler?) {
        
        var parameters = ["action":"menuUpdata"]
        guard let encoded = try? encoder.encode(menu) else {
            assertionFailure("Fail encoded")
            return
        }
//        print("encoded成功")
        parameters["menu"] = String(data: encoded, encoding: .utf8)
        
        
        if let doneHandler = doneHandler{
            doPost(dic: [0:fileName,1:#function],Menu_URL, parameters , doneHandler: doneHandler)
        }
    }
    
    func menu_with_image(fileName:NSString ,action:String,_ menu:Menu ,_ image:Data? ,
                               doneHandler: @escaping DownloadDoneHandler) {
        
//        var parameters = [Action:"menuUpdata"]
//        var parameters = [Action:"menuInsert"]
        var parameters = ["action":action]
        
        guard let encoded = try? encoder.encode(menu) else {
            assertionFailure("Fail encoded")
            return
        }
        
        guard let data = image else {
            assertionFailure("nil image data")
            return
        }
        //        print("encoded成功")
        parameters["menu"] = String(data: encoded, encoding: .utf8)
        parameters["imageBase64"] = data.base64EncodedString()
        
        doPost(dic: [0:fileName,1:#function],Menu_URL, parameters , doneHandler: doneHandler)
    }
    
    func menuUpdata_image(fileName:NSString ,_ menu_id:Int ,_ image:Data? ,
                               doneHandler:  DownloadDoneHandler?) {
        
        var parameters = ["action":"menuUpdata",
                          "menu_id":menu_id] as [String : Any]
       
        guard let data = image else {
            assertionFailure("nil image data")
            return
        }
        //        print("encoded成功")
        parameters["imageBase64"] = data.base64EncodedString()
        if let doneHandler = doneHandler{
            doPost(dic: [0:fileName,1:#function],Menu_URL, parameters , doneHandler: doneHandler)
        }
    }
    
    
    func menuDelete(fileName:NSString ,_ menu_id:Int , doneHandler:  DownloadDoneHandler?) {
                                                                //這樣寫 可以直接帶入nil
        let parameters = ["action":"menuDelete",
                          "menu_id":menu_id] as [String : Any]
        if let doneHandler = doneHandler{
            doPost(dic: [0:fileName,1:#function],Menu_URL, parameters , doneHandler: doneHandler)
        }
    }
    
    //FoodMessage
    func menuUpdata_stock(fileName:NSString ,_ menu_stock:Int,
                          menu_id:Int , doneHandler: @escaping DownloadDoneHandler) {
        
        let parameters = ["action":"menuUpdata_stock",
                          "menu_stock":menu_stock,
                          "menu_id":menu_id ] as [String : Any]
        
        doPost(dic: [0:fileName,1:#function],Menu_URL, parameters , doneHandler: doneHandler)
    }
    
    // Message
    func getCoupon(fileName:NSString ,
                   _ memderId:Int , doneHandler: @escaping DownloadDoneHandler)  {
        
        let parameters = ["action": "coupon",
                         "memderId":memderId] as [String : Any]
        
        doPost(dic: [0:fileName,1:#function], Message_URL, parameters , doneHandler: doneHandler)
    }
    
    
    //目前沒用到
    private func doPost_data(_ urlString:String,_ data:Data, doneHandler: @escaping DownloadDoneHandler){
        
        guard let url = URL(string: urlString) else {
            assertionFailure("url nil")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpBody = data
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print("\(error)")
//                doneHandler(error,nil)
            }
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                assertionFailure("server error")
                return
            }
            
            guard let data = data else{
                print("doPost_data data is nil )")
                return
            }
            
            doneHandler(nil,data)
        }
        task.resume()
        
    }
    
    private func doPost( dic:[Int:NSString],
        _ urlString:String,_ parameters:[String: Any], doneHandler: @escaping DownloadDoneHandler){
        
        guard let url = URL(string: urlString) else {
            assertionFailure("url nil")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print("  \(dic[0]): \(dic[1]):   \(error)")
//                doneHandler(error,nil)
            }
            
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
//                assertionFailure("server error")
                return
            }
            
            guard let data = data else{
                print(" data is nil : \(#function)")
                return
            }

            
            doneHandler(nil,data)
            
        }
        task.resume()

    }
    
    private func doPost_menuList(funcName:String,_ control:UITableViewController? ,_ urlString:String,_ parameters:[String: Any], doneHandler: @escaping Handler){
        
        guard let url = URL(string: urlString) else {
            assertionFailure("url nil")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print("doPost_menuList URLSession error : \(control?.description)\n \(funcName)\n\n")
                print("URLSession error : \(error)")
//                doneHandler(control,error,nil)
            }
            
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
                print("doPost_menuList response error : \(control?.description)\n \(funcName)\n\n")
//                assertionFailure("server error")
                return
            }
            
            guard let data = data else{
                print(" data is nil : \(funcName)")
                return
            }
            
            doneHandler(control,nil,data)
            
        }
        task.resume()
        
    }
    
    
    
    
    
}
