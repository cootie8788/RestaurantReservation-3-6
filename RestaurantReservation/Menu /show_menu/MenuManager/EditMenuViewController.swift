

import UIKit
import Starscream

class EditMenuViewController: UIViewController {
    
    
    @IBOutlet weak var menu_name: UITextField!
    @IBOutlet weak var kind: UISegmentedControl!
    @IBOutlet weak var menu_money: UITextField!
    @IBOutlet weak var editImage: UIImageView!
    
    
    
    let downloader = Downloader.shared
    let userDefault = UserDefaults()
    
    let decoder = JSONDecoder()
    let app = UIApplication.shared.delegate as! AppDelegate
    
    var MenuTableC_sw = 0
    var MenuTableC_index = 0
    var deleteSW = false
    
    var socket = SocketClient.chatWebSocketClient
    
    
    private let cashesURL :URL =
    {
        //大概以後 會加入其他程式碼 先習慣吧   默認路徑一定拿得到 ！！！
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }()
    
    private func RemoveRetrieveFileNames(_ id:Int){
//        print("CashesURL: \(cashesURL)")
        
        let filemanager = FileManager.default
        let fullFileURL = cashesURL.appendingPathComponent("\(id)")
        
        let _ =  try? filemanager.removeItem(at: fullFileURL)
    }

    @IBAction func dismissKeybroad()  {
        view.endEditing(true) //收鍵盤
    }
    
    @IBAction func EditImageBt(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "Choose photo from:", message: nil, preferredStyle: .alert)
        let library = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.lauchPicker(forType: .photoLibrary)
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.lauchPicker(forType: .camera)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert,animated: true)
        
//        editImage.image = UIImage(named: "喵")
        
    }
    
    @IBAction func UpImageBt(_ sender: UIButton) {
        
        
        if let image = editImage.image {
            //只上傳圖片
            let id = app.menuList[MenuTableC_sw][MenuTableC_index].id
            let data = UIImageJPEGRepresentation(image, 100)
            
            downloader.menuUpdata_image(fileName:#file, id, data) { (error, data) in
                
                print("menuUpdata_with_image: \(String(describing: String(data: data, encoding: .utf8)))")
                
                self.socket.sendMessage("notifyDataSetChanged")
            }
            
            RemoveRetrieveFileNames(id)
            
            
            
            deleteSW = true
            self.performSegue(withIdentifier: "goback", sender: nil)
            //更新 所以app的menuList
        }//if
        
    }
    
    @IBAction func deleteBt(_ sender: UIButton) {
        
        let id = app.menuList[MenuTableC_sw][MenuTableC_index].id
        
        Downloader.shared.menuDelete(fileName:#file,id) { (error, data) in
            
            print("menuDelete: \(String(describing: String(data: data, encoding: .utf8)))")
            
            self.socket.sendMessage("notifyDataSetChanged")
        }
        
        deleteSW = true
        self.performSegue(withIdentifier: "goback", sender: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
        
//        menu_name.placeholder = app.menuList[MenuTableC_sw][MenuTableC_index].name
//        menu_money.placeholder = app.menuList[MenuTableC_sw][MenuTableC_index].price
        menu_name.text = app.menuList[MenuTableC_sw][MenuTableC_index].name
        menu_money.text = app.menuList[MenuTableC_sw][MenuTableC_index].price
        var type = app.menuList[MenuTableC_sw][MenuTableC_index].type
        type -= 1
        kind.selectedSegmentIndex = type
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItems?.first?.title = "jimoslgj"
        //註冊收鍵盤
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeybroad))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidDisappear(_ animated: Bool) {

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "輸入錯誤警告", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "確定", style: .default)
//        let cancel = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(ok)
//        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //觸發儲存時 要做的事情
        if segue.destination is MenuTableViewController {
            
            //不讓delete功能 做輸入判斷
            guard  deleteSW == false else {
                deleteSW = false
//                print("delete menu")
                return  }
            
            //檔住輸入
            let id = app.menuList[MenuTableC_sw][MenuTableC_index].id
            
            guard let name = menu_name.text , !name.isEmpty  else {
                showAlert("名字格式錯誤")
                return  }
            let type = self.kind.selectedSegmentIndex + 1
            guard let price = menu_money.text , !price.isEmpty  else {
                showAlert("價錢格式錯誤")
                return  }
            
            
            if let image = editImage.image {
                //有圖的上傳
                let menu = Menu(id: id, name: name, price: price, type: type, note: "", stock: 0)
                let data = UIImageJPEGRepresentation(image, 100)
                
                downloader.menu_with_image(fileName:#file,action: "menuUpdata", menu, data) { (error, data) in
                    
                    print("menuUpdata_with_image: \(String(describing: String(data: data, encoding: .utf8)))")
                    
                    self.RemoveRetrieveFileNames(id)
                    
                    self.socket.sendMessage("notifyDataSetChanged")
                    //更新 所以app的menuList
                }
                
            }else{
                
                //上傳修改  無圖
                let menu = Menu(id: id, name: name, price: price, type: type, note: "", stock: 0)
                
                downloader.menuUpdata(fileName:#file,menu) { (error, data) in
                
                    print("menuUpdata: \(String(describing: String(data: data, encoding: .utf8)))")
                    
                    self.socket.sendMessage("notifyDataSetChanged")
                    //更新 所以app的menuList
                }
                
//                downloader.menuUpdata(fileName: #file, menu, doneHandler: nil)
                //  省去closure 的寫法
                
                
            }//else
            
            
        }//if
            
            
    }
        
        
    

}
