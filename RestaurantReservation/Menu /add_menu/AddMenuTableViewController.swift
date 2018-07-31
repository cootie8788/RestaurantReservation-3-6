
import UIKit

class AddMenuTableViewController: UITableViewController {
    
    let downloader = Downloader.shared
    let decoder = JSONDecoder()
    let app = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction
    func reflush() {
        app.downloadMenuList(self)
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
 

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        tableView.reloadData()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 建立 NotificationCenter 的 接收器
        NotificationCenter.default.addObserver(self, selector: #selector(doSomething), name: Notification.Name.init("reload"), object: nil)
        
        tableView.refreshControl =  UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(reflush), for: .valueChanged)
    }
    
    @objc
    func doSomething(_ notification : Notification){
        // 取出 訊息
        guard let message = notification.userInfo?["reload"] as? String else {
            assertionFailure("Notification parse Fail")
            return
        }
        print("通知收到 \(message)")
        
        if message == "105"{
            //            reflush()
            app.downloadMenuList(self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return app.menuList[2].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordermenucell", for: indexPath) as! OrderMenuTableViewCell
        
        let id = app.menuList[2][indexPath.row].id
        let name = app.menuList[2][indexPath.row].name
        let price = app.menuList[2][indexPath.row].price
        let stock = app.menuList[2][indexPath.row].stock
        
        var num = 0
        
        if let num = app.cart[id]?.quantity {
            cell.orderMenu_cell_num.text = "\(num)"
            print("\(num)")
        }else{
            cell.orderMenu_cell_num.text = "0"
        }

        cell.orderMenu_cell_Image.showImage(urlString: downloader.Menu_URL,id: id)
        cell.orderMenu_cell_item.text = name
        cell.orderMenu_cell_money.text = price
        
        cell.tag = indexPath.row  //給cell  他自己所對應的table index
        cell.cellID = id          //給cell  所對應的orderMenu id
        cell.cellName = name
        cell.cellPrice = price
        cell.cellStock = stock
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
