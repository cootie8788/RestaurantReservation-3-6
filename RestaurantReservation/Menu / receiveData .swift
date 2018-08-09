

import UIKit

class receiveData {
    
    var app : AppDelegate?
    var controler : UITableViewController?
    
    func onSet(_ ctrler :UITableViewController)  {// first
        //reflush()
        app = UIApplication.shared.delegate as! AppDelegate
        controler = ctrler
        
        tableRefreshCtrler(ctrler)
        notificationCenter()
        
    }
    
    func tableRefreshCtrler(_ ctrler :UITableViewController) {
        ctrler.tableView.refreshControl =  UIRefreshControl()
        ctrler.tableView.refreshControl?.addTarget(self, action: #selector(reflush), for: .valueChanged)
        ctrler.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "更新中")
    }
    func notificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(doSomething), name: Notification.Name.init("reload"), object: nil)
    }
    
    @objc
    func reflush() {
        
        controler?.tableView.refreshControl?.beginRefreshing()
        if let app = app {
            app.downloadMenuList(controler)
        }
        controler?.tableView.refreshControl?.endRefreshing()
    }
    
    
    @objc
    func doSomething(_ notification : Notification){
        // 取出 訊息
        guard let message = notification.userInfo?["reload"] as? String else {
            assertionFailure("Notification parse Fail")
            return
        }
        print("MenuTable 通知收到 \(message)")
        
        if message == "notifyDataSetChanged"{
            controler?.tableView.reloadData()
        }
    }
    
    
}
