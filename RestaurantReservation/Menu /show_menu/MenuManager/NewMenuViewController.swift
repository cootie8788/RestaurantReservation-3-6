

import UIKit
import Photos
import Starscream

class NewMenuViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var newImage: UIImageView!
    @IBOutlet weak var menu_name: UITextField!
    @IBOutlet weak var menu_kind: UISegmentedControl!
    @IBOutlet weak var menu_price: UITextField!
    @IBOutlet weak var menu_stock: UITextField!

    let downloader = Downloader.shared
    let userDefault = UserDefaults()
    let decoder = JSONDecoder()
    let app = UIApplication.shared.delegate as! AppDelegate
    
    var socket = SocketClient.chatWebSocketClient
    
    private let picker = UIImagePickerController()
    private let cropper = UIImageCropper(cropRatio: 4/3)
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.leftBarButtonItems?.first?.title = "jimoslgj"
        
        menu_name.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeybroad))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cropper.delegate = self
        
        navigationItem.leftBarButtonItems?.first?.title = "jimoslgj"

    }
    
    @IBAction func editImageBt(_ sender: UIButton) {
        
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
        
        
        //        newImage.image = UIImage(named: "喵")
    }
    
    @IBAction func dismissKeybroad()  {
        view.endEditing(true)
    }
    
    func showAlert(_ message:String){
        let alert = UIAlertController(title: "輸入錯誤警告", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "確定", style: .default)
//        let cancel = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(ok)
//        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //目前只有一條    這是判斷回去的那一條
        if  segue.destination is MenuTableViewController{
            print("有回去嗎")
            
            guard let name = menu_name.text , !name.isEmpty  else {
                showAlert("名字格式錯誤")
                return  }
            let type = menu_kind.selectedSegmentIndex + 1
            guard let price = menu_price.text , !price.isEmpty  else {
                showAlert("價錢格式錯誤")
                return  }
            guard let stockString = menu_stock.text , !stockString.isEmpty ,
            let stock = Int(stockString) else {
                showAlert("庫存格式錯誤")
                return  }
            
            guard let image = newImage.image  else {
                showAlert("沒有圖片")
                return  }
            print("輸出")
        
        
            //有圖的上傳
            let menu = Menu(id: 0, name: name, price: price, type: type, note: "", stock: stock)
            let data = UIImageJPEGRepresentation(image, 100)
            
            downloader.menu_with_image(fileName:#file,action: "menuInsert", menu, data) { (error, data) in
                
                print("menuInsert: \(String(describing: String(data: data, encoding: .utf8)))")
                
                self.socket.sendMessage("notifyDataSetChanged")
            }
     
        }

    }
    
    // 點return就收鍵盤
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension NewMenuViewController: UIImageCropperProtocol{
    
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        newImage.image = croppedImage
    }
    
}
