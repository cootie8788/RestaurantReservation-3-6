

import Foundation
import Starscream


class SocketClient : WebSocketDelegate{

    static let SocketUrl = "http://localhost:8080/RestaurantReservationApp_Web/updateStock/"
    static let chatWebSocketClient = SocketClient(url: SocketUrl+"1")

//        +"\(UserDefaults.standard.integer(forKey: "memederId"))")

    var url : URL
    var socket : WebSocketClient

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
//        let app = UIApplication.shared.delegate as! AppDelegate
//        app.downloadMenuList(nil)
        //改到 那頁收到通知在去叫下載更新

        let message : [String:String] = ["reload" : text]
        NotificationCenter.default.post(name: Notification.Name.init("reload"), object: nil, userInfo: message)
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {

    }

    //1. confirm 切到 check 會發送
    //2. edit 完
    //3. new 完

    //接收
    // 除了edit new 其他都會收到通知 做更新


    



}
