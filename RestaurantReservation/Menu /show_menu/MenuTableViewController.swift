

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
    
    let reData = receiveData()
    
    let socket = SocketClient.chatWebSocketClient
    
    @IBAction
    func goback(segue:UIStoryboardSegue)  {
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        if socket.socket.delegate == nil{
            print("socket 連線")
            socket.startLinkServer()
        }
        
        reData.onSet(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        app.downloadMenuList(self)
        
        // 建立 NotificationCenter 的 接收器
//        NotificationCenter.default.addObserver(self, selector: #selector(doSomething), name: Notification.Name.init("reload"), object: nil)
//
//        tableView.refreshControl =  UIRefreshControl()
//        tableView.refreshControl?.addTarget(self, action: #selector(reflush), for: .valueChanged)
//        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中")
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
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
