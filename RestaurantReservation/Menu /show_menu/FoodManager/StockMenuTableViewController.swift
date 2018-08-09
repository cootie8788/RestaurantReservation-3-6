

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
    
    let reData = receiveData()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reData.onSet(self)
        app.downloadMenuList(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //        socket.stopLinkServer()
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100 //or whatever you need
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
