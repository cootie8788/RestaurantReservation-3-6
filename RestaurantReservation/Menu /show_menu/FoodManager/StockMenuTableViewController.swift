

import UIKit
import Starscream


class StockMenuTableViewController: UITableViewController  {

    @IBOutlet weak var Segmented_SW: UISegmentedControl!
    @IBAction func Segmentedaction(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    let downloader = Downloader.shared
    let userDefault = UserDefaults()
    
    let decoder = JSONDecoder()
    let app = UIApplication.shared.delegate as! AppDelegate
    
    var socket = SocketClient.chatWebSocketClient

    var selectIndex = 0
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        app.downloadMenuList(self)
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中")
    }
    
    @IBAction
    func reflush() {
        app.downloadMenuList(self)
        
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        socket.stopLinkServer()
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
        
        if app.menuList.count > 0 {
            
            if Segmented_SW.selectedSegmentIndex == 0{
                return app.menuList[0].count
            }else if Segmented_SW.selectedSegmentIndex == 1{
                return app.menuList[1].count
            }else{
                return app.menuList[2].count
            }
            
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockmenucell", for: indexPath) as! StockTableViewCell
        
        let id = app.menuList[Segmented_SW.selectedSegmentIndex][indexPath.row].id
        
        cell.FoodImage.showImage(urlString: downloader.Menu_URL,
                                 id: app.menuList[Segmented_SW.selectedSegmentIndex][indexPath.row].id)
        let stock = app.menuList[Segmented_SW.selectedSegmentIndex][indexPath.row].stock
        
        cell.menu_name.text = app.menuList[Segmented_SW.selectedSegmentIndex][indexPath.row].name
        cell.menu_stock.setTitle("\((stock))", for: .normal)
        
        cell.controler = self
        cell.tag = id
        
        return cell
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
