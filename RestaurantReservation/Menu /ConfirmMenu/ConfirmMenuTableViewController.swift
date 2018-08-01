

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
        
        let member_id = self.userDefault.integer(forKey: MemberKey.MemberID.rawValue) ?? -1
//        print("member_id: \(member_id)")
        
        //連網路抓 Coupon
        Downloader.shared.getCoupon(fileName:#file,member_id) { (error, data) in   //member_id
            
//            print("\(String(data: data, encoding: .utf8))")
            
            guard let coupon = try? self.decoder.decode(Coupon.self, from: data)  else {
                assertionFailure("Fail decode")
                return  }
//            print("\(coupon)")
            
            self.coupon = coupon
        
            self.userDefault.setValue(coupon.coupon, forKey: "coupon")
            self.userDefault.setValue(coupon.discount, forKey: "discount")
            self.userDefault.synchronize()

            self.showAlert()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
//        socket.startLinkServer()
        
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
        
        for (_ ,value) in app.cart {
            array.append(value)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextpresent(){
//        let checkvc =
//            self.storyboard?.instantiateViewController(withIdentifier: "checkvc") as! UINavigationController
        
        guard let checkvc =  self.storyboard?.instantiateViewController(withIdentifier: "checkvc") as? UINavigationController else {
            assertionFailure("Fail present")
            return  }
        
        checkvc.modalPresentationStyle = .currentContext//設定覆蓋目前內容
        //上面是 CheckViewController 前的 UINavigationController
        self.present(checkvc, animated: true, completion: nil)
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "選擇優惠卷", message: nil, preferredStyle: .alert)
        
        let item1 = UIAlertAction(title: coupon?.coupon ?? "無", style: .default) { (alert) in
            
            //判斷 用哪一種 table上傳
            
            let memberID =
                self.userDefault.string(forKey: MemberKey.MemberID.rawValue) ?? "-1"
//
//            let table_member = self.userDefault.string(forKey: "table_member")
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
            let table_member = "8"
//            let person = "7"
//            let date = Date()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyy-MM-dd"
            
            var cart = [OrderMenu]()
            
            for (_ , orderMenu) in self.app.cart{
                cart.append(orderMenu)
            }
            
        
            if  table_member == "7"{
                
                
                self.downloader.orderInsert(fileName:#file,total_money: money, memberID: memberID, cart: cart, table_member: table_member, doneHandler: { (error, data) in
                    
                    
                    print("\(String(data: data, encoding: .utf8))")
//                     string.data(using: .utf8)
        
                    let de = JSONDecoder()  //解碼可以解外面是String的"json格式"

                    guard let respone = try? de.decode(respone_orderId.self, from: data)  else {
                        assertionFailure("Fail orderInsert")
                        return  }

                    print(respone.orderId)
                    
                    if respone.orderId != "-1" {
                        print("上傳成功")
                        DispatchQueue.main.async(execute: {
    
                            self.userDefault.setValue(respone.orderId, forKey: "orderid")
                            self.userDefault.synchronize()
                            
                            //                        let order = self.userDefault.string(forKey: "orderid") ?? "-1"
                            //                        print("input order ???\(order)")
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
                    
                    print("\(String(data: data, encoding: .utf8))")
                    
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
        let item2 = UIAlertAction(title: "項目2", style: .default)
        let item3 = UIAlertAction(title: "項目3", style: .default)
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        
        alert.addAction(item1)
        //        alert.addAction(item2)
        //        alert.addAction(item3)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

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
        cell.cellPrice = price
        cell.cellStock = stock
        
        cell.ctrler = self
        cell.menu_count = menu_count
        cell.money_total = money_total
        
        return cell
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