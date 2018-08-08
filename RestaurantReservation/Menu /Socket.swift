

import Foundation
import Starscream


class SocketClient : WebSocketDelegate{

//    static let SocketUrl = "http://localhost:8080/RestaurantReservationApp_Web/updateStock/"
    static let SocketUrl = "http://192.168.50.65:8080/RestaurantReservationApp_Web/updateStock/"
    static let chatWebSocketClient =
        SocketClient(url:
            SocketUrl+"\(UserDefaults.standard.integer(forKey: MemberKey.MemberID.rawValue))")

    var url : URL
    var socket : WebSocketClient
    
    var app : AppDelegate?
    
    var controler : UITableViewController?
    
    
    init(url : String) {
        self.url = URL(string: url)!
        self.socket = WebSocket(url: self.url)
    }

    func startLinkServer(){
        socket.delegate = self
        socket.connect()
    }

    func stopLinkServer() {
        socket.disconnect()
        socket.delegate = nil
    }
    
    private let cashesURL :URL =
    {
        //大概以後 會加入其他程式碼 先習慣吧   默認路徑一定拿得到 ！！！
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }()
    
//    func connection(){
//        let socket = WebSocket(url: URL(string: "http://localhost:8080/RestaurantReservationApp_Web/updateStock/1")!)
//        socket.delegate = self
//        socket.connect()
//    }

    func sendMessage(_ message : String) {
        socket.write(string: message)
    }


    // 默認的函數
    func websocketDidConnect(socket: WebSocketClient) {
        print("socket is connect") //連線就會動
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {

        print("error xxxxxxxxxxxxxxxxxxxxxxxxxxx")
        //只有閃退的時候會執行這邊的Disconnect

        socket.disconnect()
        print("socket is disconnect")
    }


    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {

        print("\(text)")       //訊息 連線關閉就收不到了 時間要隔開 server延遲1秒

        // 解析 text (server送出的是jsonString) 成 Json Data
//        guard let jsonData = text.data(using: .utf8) else {
//            assertionFailure("cast to data fail")
//            return
//        }

//        guard let chat = try? JSONDecoder().decode(Chat.self,from : jsonData) else {
//            assertionFailure("cast to chat fail")
//            return
//        }


        //收到訊息就去做 刷新MenuList的動作
        let app = UIApplication.shared.delegate as! AppDelegate
        
        Downloader.shared.test(nil) { (controler, error, data) in

            //            print("data: \(String(describing: String(data: data, encoding: .utf8)))")
            guard let MenuArray = try? JSONDecoder().decode([[Menu]].self, from: data) else{
                assertionFailure("Fail decoder")
                return}

            

            DispatchQueue.main.async {
                
                app.menuList = MenuArray
                print("\(app.menuList)\n")
                
                let filemanager = FileManager.default
                
                if let results = try?filemanager.contentsOfDirectory(atPath: self.cashesURL.path){
                    
                    for item in results{
//                        let remove =  try? filemanager.removeItem(atPath:target)
                        let url = self.cashesURL.appendingPathComponent(item)
//                        print("item: \(url)")
                        let _ =  try? filemanager.removeItem(at: url)
                    }
                }
                
                
                let message : [String:String] = ["reload" : text]
                NotificationCenter.default.post(name: Notification.Name.init("reload"), object: nil, userInfo: message)
            }
        }
        

//        let message : [String:String] = ["reload" : text]
//        NotificationCenter.default.post(name: Notification.Name.init("reload"), object: nil, userInfo: message)
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {

    }

    //1. confirm 切到 check 會發送
    //2. edit 完
    //3. new 完

    //接收
    // 除了edit new 其他都會收到通知 做更新

//    struct func jim() {
//
//    }
    
    
//    func onSet(_ ctrler :UITableViewController)  {
//        //reflush()
//        app = UIApplication.shared.delegate as! AppDelegate
//        controler = ctrler
//    
//        tableRefreshCtrler(ctrler)
//        notificationCenter()
//    
//    }
//    
//    func tableRefreshCtrler(_ ctrler :UITableViewController) {
//        ctrler.tableView.refreshControl =  UIRefreshControl()
//        ctrler.tableView.refreshControl?.addTarget(self, action: #selector(reflush), for: .valueChanged)
//        ctrler.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中")
//    }
//    func notificationCenter() {
//        NotificationCenter.default.addObserver(self, selector: #selector(doSomething), name: Notification.Name.init("reload"), object: nil)
//    }
//    
//    @objc
//    func reflush() {
//    
//        controler?.tableView.refreshControl?.beginRefreshing()
//        if let app = app {
//            app.downloadMenuList(controler)
//        }
//        controler?.tableView.refreshControl?.endRefreshing()
//    }
//    
//    
//    @objc
//    func doSomething(_ notification : Notification){
//        // 取出 訊息
//        guard let message = notification.userInfo?["reload"] as? String else {
//            assertionFailure("Notification parse Fail")
//            return
//        }
//        print("MenuTable 通知收到 \(message)")
//        
//        if message == "notifyDataSetChanged"{
//            controler?.tableView.reloadData()
//        }
//    }
    
    
    
}
