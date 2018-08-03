//
//  OrderMenuTableViewController.swift
//  RestaurantReservation
//
//  Created by Jim on 2018/7/21.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

class OrderMenuTableViewController: UITableViewController, OrderMenuTableViewCellDelegate {
    
    func getSomething(_ cell: UITableViewCell)
        -> (id: Int, name: String, price: String, stock: Int, type: Int)? {
        guard let index = tableView.indexPath(for: cell)?.row else {
            assertionFailure("")
            return  nil}
        
        let id = app.menuList[orderMenuSwitch.selectedSegmentIndex][index].id
        let name = app.menuList[orderMenuSwitch.selectedSegmentIndex][index].name
        let price = app.menuList[orderMenuSwitch.selectedSegmentIndex][index].price
        let stock = app.menuList[orderMenuSwitch.selectedSegmentIndex][index].stock
        let type = orderMenuSwitch.selectedSegmentIndex + 1
        
        return (id,name,price,stock,type)
    }
    
    func jim() -> (name: Int, jim: String) {
        return (3,"jim")
    }

  
    
    @IBOutlet weak var orderMenuSwitch: UISegmentedControl!
    
    @IBAction func orderMenuSWaction(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    @IBAction
    func reflush() {
        downloadList()
        //        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
   
    
    var num = 0
    
    
    let downloader = Downloader.shared
    let decoder = JSONDecoder()
    let app = UIApplication.shared.delegate as! AppDelegate
    let userDefault = UserDefaults()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        
        let TableNumber = userDefault.string(forKey: MemberKey.TableNumber.rawValue) ?? "預訂點餐"
        
        
        switch TableNumber {
        case "5":
            self.navigationItem.title = "外帶"  //有tableMember
        case "預訂點餐":
            self.navigationItem.title = "預訂點餐"  
        default:
            self.navigationItem.title = "內用 \(TableNumber)號桌"  //有tableMember
        }
        
        
        
        tableView.reloadData()
        
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.pushViewController((navigationController?.viewControllers[0])!, animated: true)
       
//        downloadList()
        
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
        print("OrderMenu 通知收到 \(message)")
        
        if message == "105"{
//                        reflush()
            tableView.reloadData()
//            app.downloadMenuList(self)
        }
    }
    
    func downloadList(){
        app.downloadMenuList(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if app.menuList.count > 0 {
            
            if orderMenuSwitch.selectedSegmentIndex == 0{
                return app.menuList[0].count
            }else{
                return app.menuList[1].count
            }
            
        }
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ordermenucell", for: indexPath) as! OrderMenuTableViewCell
        
        
        let id = app.menuList[orderMenuSwitch.selectedSegmentIndex][indexPath.row].id
        let name = app.menuList[orderMenuSwitch.selectedSegmentIndex][indexPath.row].name
        let price = app.menuList[orderMenuSwitch.selectedSegmentIndex][indexPath.row].price
        let stock = app.menuList[orderMenuSwitch.selectedSegmentIndex][indexPath.row].stock
        
        
        if let num = app.cart[id]?.quantity {
            cell.orderMenu_cell_num.text = "\(num)"
            print("\(num)")
        }else{
            cell.orderMenu_cell_num.text = "0"
        }
        
        cell.orderMenu_cell_Image.showImage(urlString: downloader.Menu_URL,id: id)
        cell.orderMenu_cell_item.text = name
        cell.orderMenu_cell_money.text = price
        
        cell.delegate = self  //所有的cell delegate都要
        cell.tag = indexPath.row  //給cell  他自己所對應的table index
        cell.cellID = id          //給cell  所對應的orderMenu id
        cell.cellName = name
        cell.cellPrice = price
        cell.cellStock = stock
        cell.type = orderMenuSwitch.selectedSegmentIndex + 1
        
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
