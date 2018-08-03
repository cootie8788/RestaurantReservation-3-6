

import UIKit
import Starscream

class MenuTableViewController: UITableViewController {
    
    @IBOutlet weak var meeu_switch: UISegmentedControl!
    @IBAction func Segment_action(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    let downloader = Downloader.shared
    let decoder = JSONDecoder()
    let app = UIApplication.shared.delegate as! AppDelegate
    
    
    let socket = SocketClient.chatWebSocketClient
    
    @IBAction
    func goback(segue:UIStoryboardSegue)  {
        
    }
    
    @IBAction
    func reflush() {
        downloadList()
//        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
        
    }
    
    func downloadList(){
        app.downloadMenuList(self)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        downloadList()
        
        if socket.socket.delegate == nil{
            print("socket 連線")
            socket.startLinkServer()
        }
        
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
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
        print("MenuTable 通知收到 \(message)")
        
        if message == "105"{
            
            tableView.reloadData()
//            reflush()
//            app.downloadMenuList(self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if app.menuList.count > 0 {
            
            if meeu_switch.selectedSegmentIndex == 0{
                return app.menuList[0].count
            }else if meeu_switch.selectedSegmentIndex == 1{
                return app.menuList[1].count
            }else{
                return app.menuList[2].count
            }
            
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menucell", for: indexPath) as! MenuTableViewCell

        cell.cellImage.showImage(urlString: downloader.Menu_URL,
                                 id: app.menuList[meeu_switch.selectedSegmentIndex][indexPath.row].id)
        cell.cellitem.text = app.menuList[meeu_switch.selectedSegmentIndex][indexPath.row].name
        cell.cellmoney.text =
        "$\(app.menuList[meeu_switch.selectedSegmentIndex][indexPath.row].price)"
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        socket.sendMessage("3455555")
    }

   

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let control =  segue.destination as? EditMenuViewController{
            
            control.MenuTableC_sw = meeu_switch.selectedSegmentIndex
            control.MenuTableC_index = (self.tableView.indexPathForSelectedRow!.row)
        }
    }
    

}
