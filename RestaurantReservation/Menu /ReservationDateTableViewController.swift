//
//  ReservationDateTableViewController.swift
//  RestaurantReservation
//
//  Created by 林沂諺 on 2018/7/27.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//
//定位時間畫面
import UIKit
var upload = ""
class ReservationDateTableViewController: UITableViewController {
    
    @IBOutlet weak var numberOfTextField: UITextField!//人數TextField
    @IBOutlet weak var timeTextField: UITextField!//時間TextField
    @IBOutlet weak var dateTextField: UITextField! //日期TextField
    
    let numberOfPeoples = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15","16", "17", "18", "19", "20"]
    let communicator =  CommunicatorOrder()
    var timePick = UIDatePicker()
    var datePick = UIDatePicker()
    var orderID = OrderID()
    var date = ""
    var time = ""
    var person = ""
    var memberIDInter = -1
    let userDefault = UserDefaults()
    //    let table_member = self.userDefault.string(forKey: MemberKey.TableNumber.rawValue)
    //    let person = self.userDefault.string(forKey: "person")
    //    let date = self.userDefault.string(forKey: "date")
    
    var selectPeople: String? //選擇人數
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let memberID = UserDefaults.standard.string(forKey: MemberKey.MemberID.rawValue)
        guard let memberIDInt = Int(memberID!) else {
            assertionFailure("get MemberID Fail")
            return
        }
        memberIDInter = memberIDInt
        creatDatePicker()
        creatTimePicker()
        createPeolePiceker()
        
    }
    
    var con : UINavigationController?
    
    var firstAction = true
    
    @IBAction func peopleAction(_ sender: UITextField) {
        if firstAction {
            firstAction = false
            numberOfTextField.text = "1"
            person = numberOfTextField.text!
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // 創造時間picker
    func creatTimePicker() {
        timePick.datePickerMode = .time
        timePick.backgroundColor = UIColor.white
        timePick.locale = Locale(identifier: "zh_TW")
        timeTextField.inputView = timePick
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "確定", style: .done, target: nil, action: #selector(timeDoneClicked))
        toolbar.setItems([doneButton], animated: true)
        timeTextField.inputAccessoryView = toolbar
    }
    // 創造日期picker
    func creatDatePicker(){
        //格式化 顯示的 datePick
        datePick.datePickerMode = .date
        datePick.locale = Locale(identifier: "zh_TW")
        datePick.backgroundColor = UIColor.white
        //將datePick 加到TextField
        dateTextField.inputView = datePick
        //ceret toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //toolbar 增加完成按紐
        let doneButton = UIBarButtonItem(title: "確定", style: .done, target: nil, action: #selector(doneClicked))
        toolbar.setItems([doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar //要開啟虛擬鍵盤都需透過inputAccessoryView
        datePick.maximumDate = sevenDaysfromNow //設定最大日期
        datePick.minimumDate = datePick.date //設定最小日期
    }
    
    //日期picker:計算未來或者過去的日期
    var sevenDaysfromNow: Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: 30, to: Date(), options: [])!
    }
    
    
    
    //日期#selector
    @objc
    func doneClicked() {
        //再次選擇前清除
        upload = ""
        // 格式化顯示在TextField 日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = dateFormatter.string(from: datePick.date)
        self.view.endEditing(true)
        
    }
    
    //時間#selector
    @objc
    func timeDoneClicked() {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeTextField.text = timeFormatter.string(from: timePick.date)
        upload = dateTextField.text! + " " + timeTextField.text! + ":00"
        print("upload:\(upload)")
        self.view.endEditing(true)
        
        userDefault.setValue(upload, forKey: "date")
        userDefault.synchronize()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     */
    func createPeolePiceker() {
        let peoplePicker = UIPickerView()
        peoplePicker.delegate = self
        peoplePicker.backgroundColor = UIColor.white
        numberOfTextField.inputView = peoplePicker
        creatPeopleToolbar()
    }
    
    func creatPeopleToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "確定", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        numberOfTextField.inputAccessoryView = toolbar
        
        
    }
    @objc//人數#selector
    func dismissKeyboard() {
        view.endEditing(true)
    }
    //定位確認扭
    @IBAction func confirmBarBtn(_ sender: UIBarButtonItem) {
        if (timeTextField.text?.isEmpty)! || (dateTextField.text?.isEmpty)! || (numberOfTextField.text?.isEmpty)! {
            let alert = UIAlertController(title: "請填寫定位資訊", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "確定", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }else {
            //            self.present(con!, animated: true, completion: nil)
            
            let alert = UIAlertController(title: "定位", message: "", preferredStyle: .alert)
            
            //定位確認扭 三個AlertAction 1繼續點餐. 2.取消 3.定位不點餐
            //            let continueAction = UIAlertAction(title: "繼續點餐", style: .default, handler: nil)
            let continueAction = UIAlertAction(title: "繼續點餐", style: .default) { (action) in
                
                self.userDefault.setValue("預訂點餐", forKey: MemberKey.TableNumber.rawValue)
                self.userDefault.synchronize()
                self.performSegue(withIdentifier: "OrderMenu", sender: nil)
                
            }
            
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let notOrder = UIAlertAction(title: "定位不點餐", style: .default) { (action) in
                
                self.uploaddateTask() //上傳時間日期人數
                //定位不點餐裡面的Alert
                let alert = UIAlertController(title: "定位完成", message: "若要稍後點餐請至訂單查詢修改", preferredStyle: .alert)
                let checkAction = UIAlertAction(title: "前往訂單查詢", style: .default, handler: { (action) in
                    // 在OrderTableViewController 設變數變數OrderID為staic
                    newOrderTableViewControllerOrderID = self.orderID.orderId
                    newOrderTableViewDetailControllerOrderID = self.orderID.orderId
                    print("newOrderTableViewDetailControllerOrderID:\(newOrderTableViewControllerOrderID)")
                    self.cancelTextField()
                    self.tabBarController?.selectedIndex = 2
                    
                })
                let messageAction = UIAlertAction(title: "返回優惠訊息", style: .default, handler: { (action) in
                    self.tabBarController?.selectedIndex = 0
                })
                alert.addAction(checkAction)
                alert.addAction(messageAction)
                self.present(alert, animated: true, completion: nil)
            }
            //            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(continueAction)
            alert.addAction(notOrder)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    //清空時間人數文字
    func cancelTextField() {
        timeTextField.text = ""
        dateTextField.text = ""
        numberOfTextField.text = ""
    }
    
    //上傳時間日期人數方法
    func uploaddateTask() {
        let action = dateInfo(action: "insert", date: upload, person: person, memberId: memberIDInter)
        let econder = JSONEncoder()
        econder.outputFormatting = .init()
        guard let uploadDate = try? econder.encode(action) else {
            assertionFailure("JSON encode Fail")
            return
        }
        communicator.doPost(url: ORDER_URL, data: uploadDate) { (error, result) in
            guard let result = result else{
                assertionFailure("get data fail")
                return
            }
            let outPutOrderId = String(data: result, encoding: .utf8)
            guard let outOrderId = outPutOrderId else {
                assertionFailure("abc in nil")
                return
            }
            self.orderID.orderId = Int(outOrderId) ?? 0
        }
    }
}

extension ReservationDateTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //人數picket 設置選擇框列數為1列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfPeoples.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numberOfPeoples[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectPeople = numberOfPeoples[row]
        numberOfTextField.text = selectPeople
        person = numberOfTextField.text!
        
        firstAction = false
        //人數取得
        userDefault.setValue(selectPeople, forKey: "person")
        userDefault.synchronize()
    }
}
