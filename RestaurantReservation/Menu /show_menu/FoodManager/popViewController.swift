

import UIKit
import Starscream

protocol popViewControllerDelegate: class {
    
    func getUIbBt_change_stockutton(_ num:Int)
}


class popViewController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    weak var delegate : popViewControllerDelegate?
    
    var array = [0,1,2,3,4,5,6,7,8,9]
    var num = 0
    var menu_id = 0
    
    var socket = SocketClient.chatWebSocketClient
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(array[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let picker1 = pickerView.selectedRow(inComponent: 0)
        let picker2 = pickerView.selectedRow(inComponent: 1)
        let picker3 = pickerView.selectedRow(inComponent: 2)
        num = picker1 * 100 + picker2 * 10 + picker3
        print("\(num)")
    }
    
    
    let downloader = Downloader.shared
    let userDefault = UserDefaults()
    
    let decoder = JSONDecoder()
    let app = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var StockPick: UIPickerView!
    
    @IBAction func ok(_ sender: UIButton) {
        
        
        
        dismiss(animated: true) {
            
            guard let StockMenu =
                self.storyboard?.instantiateViewController(withIdentifier: "StockMenu")as? StockMenuTableViewController else{
                    return
            }
            
            
            self.delegate?.getUIbBt_change_stockutton(self.num)
            
            self.downloader.menuUpdata_stock(fileName: #file,self.num, menu_id: self.menu_id) { (error, data) in
                
                print("menuUpdata_with_image: \(String(describing: String(data: data, encoding: .utf8)))")
                
                self.socket.sendMessage("notifyDataSetChanged")
            }
            
        }//dismiss(animated: true)
        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        StockPick.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeybroad))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func dismissKeybroad()  {
        dismiss(animated: true, completion: nil)
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
