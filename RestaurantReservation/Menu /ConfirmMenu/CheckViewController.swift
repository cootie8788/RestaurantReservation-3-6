

import UIKit
import Starscream

class CheckViewController: UIViewController , UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  array_count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "insidecell", for: indexPath) as! InsideTableViewCell
       
        cell.menu_name.text = array[indexPath.row].name
        cell.menu_count.text = array[indexPath.row].price
        cell.menu_money.text = "\(array[indexPath.row].quantity)"
        
        return cell
    }
    
    
    @IBOutlet weak var orderid: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var total_text: UILabel!
    @IBOutlet weak var discount_text: UILabel!
    @IBOutlet weak var Tableview: UITableView!
    
    
    let downloader = Downloader.shared
    let userDefault = UserDefaults()
    let decoder = JSONDecoder()
    var array_count = 0
    var array = [OrderMenu]()
    
    var socket = SocketClient.chatWebSocketClient
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let app = UIApplication.shared.delegate as! AppDelegate
        
        array_count = app.cart.count
        var total = 0
        
        for (_ ,value) in app.cart {
            
            total += (value.quantity * (Int(value.price) ?? 0))
            array.append(value)
        }
        
        let discount = self.userDefault.double(forKey: "discount")
//        let date = self.userDefault.String(forKey: "date")

        let order = self.userDefault.string(forKey: "orderid") ?? "-1"
        print("order ???\(order)")
        
        let date_test = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        let stringTime = dateFormatter.string(from: date_test)
        
    
        orderid.text = order
        date.text = stringTime
        discount_text.text = "\(discount)折"
        
        if discount == 0{
            total_text.text = "\(total)"
        }else{
            total = Int(Double(total) * discount)
            total_text.text = "\(total)"
        }
        //  要刪除 之前存的偏好數值
        userDefault.removeObject(forKey: "coupon")
        userDefault.removeObject(forKey: "discount")
        
        Tableview.delegate = self
        Tableview.dataSource = self
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        socket.stopLinkServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
