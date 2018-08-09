

import UIKit
import Starscream


class ConfirmMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var menu_count: UILabel!
    @IBOutlet weak var money_total: UILabel!
    
    let downloader = Downloader.shared
    let userDefault = UserDefaults()
    
    let decoder = JSONDecoder()
    let app = UIApplication.shared.delegate as! AppDelegate
    
    var coupon : Coupon? = nil
    var array = [OrderMenu]()
    var totalMoney = 0
    
    
    var socket = SocketClient.chatWebSocketClient
    
   
    
    @IBAction func bar_Bt_action(_ sender: UIBarButtonItem) {
        
        
        guard  app.cart.count > 0 else{
            
            let alert2 = UIAlertController(title: "錯誤提示", message: "目前購物車為空", preferredStyle: .alert)
            
            let item2 = UIAlertAction(title: "確定", style: .default)
            alert2.addAction(item2)
            
            present(alert2, animated: true, completion: nil)
            
            return
        }
        
        
        self.showAlert()
        
        let member_id = self.userDefault.integer(forKey: MemberKey.MemberID.rawValue) ?? -1
//        print("member_id: \(member_id)")
        
        //連網路抓 Coupon
        Downloader.shared.getCoupon(fileName:#file,member_id) { (error, data) in   //member_id
            
//            print("\(String(data: data, encoding: .utf8))")
            
            guard let coupon = try? self.decoder.decode(Coupon.self, from: data)  else {
//                assertionFailure("Fail decode")
                return  }
//            print("\(coupon)")
            
            self.coupon = coupon
        
            self.userDefault.setValue(coupon.coupon, forKey: "coupon")
            self.userDefault.setValue(coupon.discount, forKey: "discount")
            self.userDefault.synchronize()

            
            
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if self.socket.socket.delegate == nil{
            print("socket 連線")
            self.socket.startLinkServer()
        }

        
        var total = 0
        
        for (_ ,value) in app.cart {
            
            total += (value.quantity * (Int(value.price) ?? 0))
            array.append(value)
        }
        menu_count.text = "\(app.cart.count)"
        money_total.text = "$\(total)"
        totalMoney = total
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        definesPresentationContext = true
        
        for (_ ,value) in app.cart {
            array.append(value)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextpresent(){
        
//        guard let checkvc =  self.storyboard?.instantiateViewController(withIdentifier: "checkvc") as? UINavigationController else {
//            assertionFailure("Fail present")
//            return  }
//        
//        checkvc.modalPresentationStyle = .currentContext//設定覆蓋目前內容
//        //上面是 CheckViewController 前的 UINavigationController
//        self.present(checkvc, animated: true, completion: nil)
        
        
        performSegue(withIdentifier: "CheckView", sender: nil)
        
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "選擇優惠卷", message: nil, preferredStyle: .alert)
        
        let item1 = UIAlertAction(title: coupon?.coupon ?? "無", style: .default) { (alert) in
            
            //判斷 用哪一種 table上傳
            
            let memberID =
                self.userDefault.string(forKey: MemberKey.MemberID.rawValue) ?? "-1"
//
            let table_member = self.userDefault.string(forKey: MemberKey.TableNumber.rawValue) ?? "預訂點餐"
            let person = self.userDefault.string(forKey: "person") ?? "0"
            let date = self.userDefault.string(forKey: "date") ?? ""
            
            var money = "\(self.totalMoney)"
            
                let discount = self.userDefault.double(forKey: "discount")
                if discount == 0{
                    money = "\(self.totalMoney)"
                }else{
                    money = "\(Int(Double(self.totalMoney) * discount))"
                }
            
//            let memberID = "1"
//            let table_member = "8"
//            let person = "7"
//            let date = Date()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyy-MM-dd"
            
            var cart = [OrderMenu]()
            
            for (_ , orderMenu) in self.app.cart{
                cart.append(orderMenu)
            }
            
        
            if  table_member != "預訂點餐"{   // tableMemeber 這邊可能是抓不到
                
                
                self.downloader.orderInsert(fileName:#file,total_money: money, memberID: memberID, cart: cart, table_member: table_member, doneHandler: { (error, data) in
                    
                    
                    print("\(String(describing: String(data: data, encoding: .utf8)))")
//                     string.data(using: .utf8)
        
                    let de = JSONDecoder()  //解碼可以解外面是String的"json格式"

                    guard let respone = try? de.decode(respone_orderId.self, from: data)  else {
                        assertionFailure("Fail orderInsert")
                        return  }   //de.decode 會失敗 閃退 ？？

                    print(respone.orderId)
                    
                    if respone.orderId != "-1" {
                        // waiter socket
                        self.giveMeOrder()
                        print("上傳成功")
                        DispatchQueue.main.async(execute: {
    
                            self.userDefault.setValue(respone.orderId, forKey: "orderid")
                            self.userDefault.synchronize()
                            
                            //                        let order = self.userDefault.string(forKey: "orderid") ?? "-1"
                            //                        print("input order ???\(order)")
                            
                            self.socket.sendMessage("notifyDataSetChanged")
                            
                            self.nextpresent()
                        })
                        
                        
                        
                    }else{
                        print("上傳失敗")
                        
                        DispatchQueue.main.async(execute: {
                            let alert_result = UIAlertController(title: "上傳失敗", message: nil, preferredStyle: .alert)
                            
                            let ok = UIAlertAction(title: "確定", style: .default)
                            alert_result.addAction(ok)
                            
                            self.present(alert_result, animated: true, completion: nil)
                        })
                        
                    }
                    
                })//orderInsert
                
            }else{
                
                self.downloader.orderInsert(fileName:#file,total_money: money, memberID: memberID, cart: cart, person: person, data: date, doneHandler: { (error, data) in
                    
                    print("\(String(describing: String(data: data, encoding: .utf8)))")
                    
                    let decdoe = JSONDecoder()  //解碼可以解外面是String的"json格式"
                    
                    guard let respone = try? decdoe.decode(respone_orderId.self, from: data)  else {
                        assertionFailure("Fail orderInsert")
                        return  }
                    
                    print("\(respone.orderId)")
                    
                    if respone.orderId != "-1" {
                        print("上傳成功")
                        DispatchQueue.main.async(execute: {
                            
                            self.userDefault.setValue(respone.orderId, forKey: "orderid")
                            self.userDefault.synchronize()
                            
                            //                        let order = self.userDefault.string(forKey: "orderid") ?? "-1"
                            //                        print("input order ???\(order)")
                            
                            self.socket.sendMessage("notifyDataSetChanged")
                            
                            self.nextpresent()
                        })
                        
                        
                    }else{
                        print("上傳失敗")
                        
                        DispatchQueue.main.async(execute: {
                            let alert_result = UIAlertController(title: "上傳失敗", message: nil, preferredStyle: .alert)
                            
                            let ok = UIAlertAction(title: "確定", style: .default)
                            alert_result.addAction(ok)
                            
                            self.present(alert_result, animated: true, completion: nil)
                        })
                        
                    }
                    

                })//orderInsert
                
            }
            
            
            
        
        }
//        let item2 = UIAlertAction(title: "項目2", style: .default)
//        let item3 = UIAlertAction(title: "項目3", style: .default)
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        
        alert.addAction(item1)
        //        alert.addAction(item2)
        //        alert.addAction(item3)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return app.cart.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordermenucell", for: indexPath)as!   OrderMenuTableViewCell
        
        
        let id = array[indexPath.row].id
        let name = array[indexPath.row].name
        let price = array[indexPath.row].price
        let count = array[indexPath.row].quantity
        let stock = array[indexPath.row].stock
        
        cell.orderMenu_cell_num.text = "\(count)"
        cell.orderMenu_cell_Image.showImage(urlString: downloader.Menu_URL,id: id)
        cell.orderMenu_cell_item.text = name
        cell.orderMenu_cell_money.text = price
        
        cell.tag = indexPath.row  //給cell  他自己所對應的table index
        cell.cellID = id          //給cell  所對應的orderMenu id
        cell.cellName = name
        cell.cellPrice = "$\(price)"
        cell.cellStock = stock
        
        cell.ctrler = self
        cell.menu_count = menu_count
        cell.money_total = money_total
        
        return cell
    }
    
    // waiter socket
    func giveMeOrder() {
        print(app.cart.count)
        var cartOrderMenu = [OrderMenu]()
        for (_,orderMenu)in app.cart {
            cartOrderMenu.append(orderMenu)
        }
        guard let tableNumber = userDefault.string(forKey: MemberKey.TableNumber.rawValue) else {
            assertionFailure("tableNumber is nil")
            return
        }
        print(tableNumber)
        var order = [String: Any]()
        order["action"] = "giveMeOrder"
        order["tableNumber"] = tableNumber
        let encoder = JSONEncoder()
        guard let jsonDataOrderMenu = try? encoder.encode(cartOrderMenu), let jsonStringOrderMenu = String(data: jsonDataOrderMenu, encoding: .utf8 ) else {
            assertionFailure("json toString Fail!")
            return
        }
        order["cart"] = jsonStringOrderMenu
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: order), let jsonString = String(data: jsonData, encoding: .utf8) else {
            assertionFailure("json toString Fail!")
            return
        }
        commonWebSocketClient?.sendMessage(jsonString)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
//        if let Checkcv = segue.destination as? CheckViewController {
//            Checkcv.orderid.text = re_order_id
//        }
       
        
    }
    

}
