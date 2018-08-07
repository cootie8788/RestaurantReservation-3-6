//
//  MessageManagerViewController.swift
//  RestaurantReservation
//
//  Created by Jim on 2018/7/31.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit
import Photos

class MessageManagerViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var messageNewTitleTextField: UITextField!
    @IBOutlet weak var messageNewStartTextField: UITextField!
    @IBOutlet weak var messageNewEndTextField: UITextField!
    @IBOutlet weak var messageNewDiscountTextField: UITextField!
    @IBOutlet weak var messageNewContentTextField: UITextField!
    @IBOutlet weak var messageNewImageView: UIImageView!
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    
    let communicator = Communicator()
    var array: [MessageInfo] = []
    var array_img: [UIImage] = []
    var messageID = 0
    var messageCouponID = 0
    var messageEditTitle = ""
    var messageEditStart = ""
    var messageEditEnd = ""
    var messageEditDiscount = ""
    var messageEditContent = ""
    var messageEditImage = UIImage()
    var datePick = UIDatePicker()
    var startDay: Date?
    var endDay: Date?
    let userDefault = UserDefaults.standard

    private let picker = UIImagePickerController()
    // if you want to set cropped image ratio 16 : 9 , put 16/9 !
    private let cropper = UIImageCropper(cropRatio: 4/3)
    
    let message_edit = UserDefaults.standard.string(forKey: "messageEdit")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageNewTitleTextField.delegate = self
        messageNewStartTextField.delegate = self
        messageNewEndTextField.delegate = self
        messageNewDiscountTextField.delegate = self
        messageNewContentTextField.delegate = self
        cropper.delegate = self
        messageNewTitleTextField.setBottomBorder()
        messageNewStartTextField.setBottomBorder()
        messageNewEndTextField.setBottomBorder()
        messageNewDiscountTextField.setBottomBorder()
        messageNewImageView.image = #imageLiteral(resourceName: "pic_pot")
        
        // Do any additional setup after loading the view.
        
        if message_edit == "edit" {
            messageNewTitleTextField.text = messageEditTitle
            messageNewStartTextField.text = messageEditStart
            messageNewEndTextField.text = messageEditEnd
            messageNewDiscountTextField.text = messageEditDiscount
            messageNewContentTextField.text = messageEditContent
            
            print(messageEditStart)
            print(messageEditEnd)
            messageNewImageView.image = messageEditImage
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save , target: self, action: #selector(saveBarBtnFnc))
        
        creatStarPicker()
        creatEndPicker()
        
    }

    @objc func saveBarBtnFnc() {
        
        guard let messageSaveTitle = messageNewTitleTextField.text, !messageSaveTitle.isEmpty else {
            showAlertController(titleText: "請輸入優惠標題!", messageText: "", okActionText: "知道了!", printText: "messageSaveTitle is empty ", viewController: self)
            return
        }
        
        guard let messageSaveStart = messageNewStartTextField.text, !messageSaveStart.isEmpty else {
            showAlertController(titleText: "請輸入優惠開始日期!", messageText: "", okActionText: "知道了!", printText: "messageSaveStart is empty ", viewController: self)
            return
        }
        
        guard let messageSaveEnd = messageNewEndTextField.text, !messageSaveEnd.isEmpty else {
            showAlertController(titleText: "請輸入優惠結束日期!", messageText: "", okActionText: "知道了!", printText: "messageSaveEnd is empty ", viewController: self)
            return
        }
        
        if let startDay = startDay, let endDay = endDay {
            let result:ComparisonResult = startDay.compare(endDay)
            
            if result == ComparisonResult.orderedDescending{
                showAlertController(titleText: "結束日期不可早於開始日期!", messageText: "", okActionText: "知道了!", printText: "endDay early than starDay ", viewController: self)
                return
            }
            
        }
        
        guard let messageSaveDiscountText = messageNewDiscountTextField.text, let messageSaveDiscount = Double(messageSaveDiscountText) else {
            showAlertController(titleText: "請輸入折扣!", messageText: "", okActionText: "知道了!", printText: "messageSaveDiscount is empty ", viewController: self)
            return
        }
        
        guard let messageSaveContent = messageNewContentTextField.text, !messageSaveContent.isEmpty else {
            showAlertController(titleText: "請輸入優惠資訊!", messageText: "", okActionText: "知道了!", printText: "messageSaveContent is empty ", viewController: self)
            return
        }
        
        guard let messageSaveImage = messageNewImageView.image, messageSaveImage != #imageLiteral(resourceName: "pic_pot") else {
            showAlertController(titleText: "請新增優惠訊息圖片!", messageText: "", okActionText: "知道了!", printText: "messageSaveImage is empty ", viewController: self)
            return
        }
        
        if message_edit == "edit" {
            
            let message = MessageInfo(id: messageID, message_title: messageSaveTitle, message_content: messageSaveContent, coupon_id: messageCouponID, coupon_discount: messageSaveDiscount, coupon_start: messageSaveStart, coupon_end: messageSaveEnd)
            
            guard let messageSaveImage1 = messageSaveImage.resize(maxWidthHeight: 700) else {
                return
            }
            let imageData = UIImageJPEGRepresentation(messageSaveImage1, 100)
            guard let base64Data = imageData?.base64EncodedString() else {
                return
            }
            var json = [String: Any]()
            json["action"] = "messageUpdate"
            let encoder = JSONEncoder()
            guard let messageJson = try? encoder.encode(message) else {
                return
            }
            guard let messageString = String(data: messageJson, encoding: .utf8) else {
                return
            }
            json["message"] = messageString
            json["imageBase64"] = base64Data
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            communicator.doPost(url: MESSAGE_URL, data: jsonData!) { (error, data) in
                guard let data = data else{
                    return
                }
                
                //output字串 data 轉 string
                let respone = String(data: data, encoding: String.Encoding.utf8)
                //檢查是否成功
                if respone != "1" {
                    showAlertController(titleText: "優惠資訊更新失敗!", messageText: "請再儲存一次", okActionText: "知道了!", printText: "優惠資訊更新失敗", viewController: self)
                    return
                }
                 print("更新儲存成功")
                
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "messageMainStoryboard") else{
                    assertionFailure("messageMainStoryboard can't find!!")
                    return
                }
                self.navigationController?.pushViewController(controller, animated: true)
            }

        }
        
        if message_edit == "new" {
            
            let message = MessageInfo(id: 0, message_title: messageSaveTitle, message_content: messageSaveContent, coupon_id: 0, coupon_discount: messageSaveDiscount, coupon_start: messageSaveStart, coupon_end: messageSaveEnd)
            guard let messageSaveImage1 = messageSaveImage.resize(maxWidthHeight: 200) else{
                return
            }
            let imageData = UIImageJPEGRepresentation(messageSaveImage1, 100)
            guard let base64Data = imageData?.base64EncodedString() else {
                return
            }
            var json = [String: Any]()
            json["action"] = "messageInsert"
            let encoder = JSONEncoder()
            guard let messageJson = try? encoder.encode(message) else {
                return
            }
            guard let messageString = String(data: messageJson, encoding: .utf8) else {
                return
            }
            json["message"] = messageString
            json["imageBase64"] = base64Data
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            communicator.doPost(url: MESSAGE_URL, data: jsonData!) { (error, data) in
                guard let data = data else{
                    return
                }
                
                //output字串 data 轉 string
                let respone = String(data: data, encoding: String.Encoding.utf8)
                //檢查是否成功
                if respone != "1" {
                    showAlertController(titleText: "優惠資訊新增失敗!", messageText: "請再儲存一次", okActionText: "知道了!", printText: "優惠資訊新增失敗", viewController: self)
                    return
                }
                print("新增儲存成功")
                
                guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "messageMainStoryboard") else{
                    assertionFailure("messageMainStoryboard can't find!!")
                    return
                }
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    // 開始日期picker
    func creatStarPicker(){
        //格式化 顯示的 datePick
        datePick.datePickerMode = .date
        datePick.locale = Locale(identifier: "zh_TW")
        datePick.backgroundColor = UIColor.white
        //將datePick 加到TextField
        messageNewStartTextField.inputView = datePick
        //ceret toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //toolbar 增加完成按紐
        let doneButton = UIBarButtonItem(title: "確定", style: .done, target: nil, action: #selector(doneStarClicked))
        toolbar.setItems([doneButton], animated: true)
        messageNewStartTextField.inputAccessoryView = toolbar //要開啟虛擬鍵盤都需透故inputAccessoryView
    }
    
    //日期#selector
    @objc
    func doneStarClicked() {
        // 格式化顯示在TextField 日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        messageNewStartTextField.text = dateFormatter.string(from: datePick.date)
        
        startDay = datePick.date
        print("S datePick.date \(datePick.date)")
        messageEditStart += "\(messageNewStartTextField.text!)"
        print("gggggg:\(upload)")
        self.view.endEditing(true)
        
    }
    
    // 開始日期picker
    func creatEndPicker(){
        
        //格式化 顯示的 datePick
        datePick.datePickerMode = .date
        datePick.locale = Locale(identifier: "zh_TW")
        datePick.backgroundColor = UIColor.white
        //將datePick 加到TextField
        messageNewEndTextField.inputView = datePick
        //ceret toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //toolbar 增加完成按紐
        let doneButton = UIBarButtonItem(title: "確定", style: .done, target: nil, action: #selector(doneEndClicked))
        toolbar.setItems([doneButton], animated: true)
        messageNewEndTextField.inputAccessoryView = toolbar //要開啟虛擬鍵盤都需透故inputAccessoryView
        datePick.maximumDate = sevenDaysfromStar //設定最大日期

        guard let start_Day = startDay else {
            return
        }
        datePick.minimumDate = startDay //設定最小日期
    }
    
//    //日期picker:計算未來或者過去的日期
    var sevenDaysfromStar: Date {
        return (Calendar.current as NSCalendar).date(byAdding: .year, value: 2, to: Date(), options: [])!
    }
    
    //日期#selector
    @objc
    func doneEndClicked() {
        // 格式化顯示在TextField 日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        messageNewEndTextField.text = dateFormatter.string(from: datePick.date)
        endDay = datePick.date
        
//        print("E datePick.date \(datePick.date)")
        messageEditEnd += "\(messageNewEndTextField.text!)"
        print("gggggg:\(upload)")
        self.view.endEditing(true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func messageAddImageBtnPress(_ sender: Any) {
        
        cropper.picker = picker
        cropper.cropButtonText = "Crop"
        cropper.cancelButtonText = "Retake"
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePicAction = UIAlertAction(title: "拍照", style: .default) { (_) in
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
        }
        let pickPicAction = UIAlertAction(title: "從相簿選擇照片", style: .default) { (_) in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(takePicAction)
        controller.addAction(pickPicAction)
        controller.addAction(cancelAction)
        self.present(controller, animated: true, completion: nil)
    
    }
    
    // 點背景收鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


extension MessageManagerViewController: UIImageCropperProtocol{
    
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        messageNewImageView.image = croppedImage
    }
    
}
