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
    
    @IBOutlet weak var messageScrollView: UIScrollView!
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
    var messageOriginalImage: UIImage?
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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan" - not work here.

        
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
            messageNewImageView.image = messageEditImage
            messageOriginalImage = messageEditImage
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save , target: self, action: #selector(saveBarBtnFnc))
        
        creatStarPicker()
        creatEndPicker()
        
    }
    
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.messageScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        messageScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        messageScrollView.contentInset = contentInset
    }
    
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
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
        
        
        if messageSaveDiscount > 1 {
            showAlertController(titleText: "折扣請介於0-1之間!", messageText: "", okActionText: "知道了!", printText: "messageSaveDiscount guard than 1", viewController: self)
            return
        }
        
        guard let messageSaveContent = messageNewContentTextField.text, !messageSaveContent.isEmpty else {
            showAlertController(titleText: "請輸入優惠資訊!", messageText: "", okActionText: "知道了!", printText: "messageSaveContent is empty ", viewController: self)
            return
        }
        
        guard var messageSaveImage = messageNewImageView.image, messageSaveImage != #imageLiteral(resourceName: "pic_pot") else {
            showAlertController(titleText: "請新增優惠訊息圖片!", messageText: "", okActionText: "知道了!", printText: "messageSaveImage is empty ", viewController: self)
            return
        }
        
        
        if message_edit == "edit" {
            messageEdit(messageID: messageID, messageSaveTitle: messageSaveTitle, messageSaveContent: messageSaveContent, messageCouponID: messageCouponID, messageSaveDiscount: messageSaveDiscount, messageSaveStart: messageSaveStart, messageSaveEnd: messageSaveEnd, messageSaveImage: messageSaveImage)
        }
        
        if message_edit == "new" {
            messageNew(messageID: 0, messageSaveTitle: messageSaveTitle, messageSaveContent: messageSaveContent, messageCouponID: 0, messageSaveDiscount: messageSaveDiscount, messageSaveStart: messageSaveStart, messageSaveEnd: messageSaveEnd, messageSaveImage: messageSaveImage)
        }
        
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "messageMainStoryboard") else{
            assertionFailure("messageMainStoryboard can't find!! (edit)")
            return
        }
        navigationController?.pushViewController(controller, animated: true)
    }

    func messageEdit(messageID: Int, messageSaveTitle: String, messageSaveContent: String, messageCouponID: Int, messageSaveDiscount: Double, messageSaveStart: String, messageSaveEnd: String ,messageSaveImage: UIImage) {
        
        let message = MessageInfo(id: messageID, message_title: messageSaveTitle, message_content: messageSaveContent, coupon_id: messageCouponID, coupon_discount: messageSaveDiscount, coupon_start: messageSaveStart, coupon_end: messageSaveEnd)
        
        var messageSaveImg = UIImage()
        
        if let messageOriginal = messageOriginalImage ,messageOriginal != messageSaveImage {
            guard let messageSave = messageSaveImage.resize(maxWidthHeight: 400) else {
                return
            }
            
            messageSaveImg = messageSave
        } else {
            messageSaveImg = messageSaveImage
        }
        
        let imageData = UIImagePNGRepresentation(messageSaveImg)

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
                showAlertController(titleText: "優惠資訊更新異常!", messageText: "請再儲存一次", okActionText: "知道了!", printText: "優惠資訊更新異常", viewController: self)
                return
            }
        }
    }

    func messageNew(messageID: Int, messageSaveTitle: String, messageSaveContent: String, messageCouponID: Int, messageSaveDiscount: Double, messageSaveStart: String, messageSaveEnd: String ,messageSaveImage: UIImage) {
        
        let message = MessageInfo(id: messageID, message_title: messageSaveTitle, message_content: messageSaveContent, coupon_id: messageCouponID, coupon_discount: messageSaveDiscount, coupon_start: messageSaveStart, coupon_end: messageSaveEnd)
        guard let messageSave = messageSaveImage.resize(maxWidthHeight: 200) else {
            return
        }
        let imageData = UIImageJPEGRepresentation(messageSave, 100)
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
                showAlertController(titleText: "優惠資訊新增異常!", messageText: "請再儲存一次", okActionText: "知道了!", printText: "優惠資訊新增異常", viewController: self)
                return
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
        datePick.minimumDate = start_Day //設定最小日期
    }
    
    //日期picker:計算未來或者過去的日期
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
        
        print("E datePick.date \(datePick.date)")
        messageEditEnd += "\(messageNewEndTextField.text!)"
        print("gggggg:\(upload)")
        self.view.endEditing(true)
        
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
    
    // 點return就收鍵盤
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension MessageManagerViewController: UIImageCropperProtocol{
    
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        messageNewImageView.image = croppedImage
    }
    
}


