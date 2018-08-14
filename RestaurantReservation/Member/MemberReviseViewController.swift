//
//  MemberReviseViewController.swift
//  RestaurantReservation
//
//  Created by user on 2018/7/26.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

class MemberReviseViewController: UIViewController,SSRadioButtonControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var againPasswordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: UIImageView!
    var radioButtonController: SSRadioButtonsController?
    var member: Member?
    var sex = 0
    
    let memberAPI = MemberAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 註冊（我在意鍵盤即將升起）的通知
        NotificationCenter.default.addObserver(self, selector:#selector(moveTextFieldUp(aNotification:)),name: .UIKeyboardWillShow, object:nil)
        
        nameTextField.delegate = self
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        againPasswordTextField.delegate = self
        phoneTextField.delegate = self

        // Do any additional setup after loading the view.
        // 設定單選
        radioButtonController = SSRadioButtonsController(buttons: manButton,womanButton)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        
        // 設定TextField的底線
        nameTextField.setBottomBorder()
        oldPasswordTextField.setBottomBorder()
        newPasswordTextField.setBottomBorder()
        againPasswordTextField.setBottomBorder()
        againPasswordTextField.setBottomBorder()
        phoneTextField.setBottomBorder()
        
        guard let member = member else {
            assertionFailure("member is nil")
            return
        }
        nameTextField.text = member.name
        emailLabel.text = member.email
        phoneTextField.text = member.phone
        
        // Set radio button deafult
        if member.sex == 1 {
            radioButtonController?.pressed(manButton)
        } else {
            radioButtonController?.pressed(womanButton)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectButton(selectedButton: UIButton?) {
        if selectedButton == manButton {
            sex = 1
        } else {
            sex = 2
        }
    }

    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        if member?.password != oldPasswordTextField.text {
            print("密碼錯誤")
            alert(message: "密碼錯誤")
            return
        }
        
        if newPasswordTextField.text != againPasswordTextField.text {
            print("再次輸入密碼錯誤")
            alert(message: "再次輸入密碼錯誤")
            return
        }
        
        guard let name = nameTextField.text, let password = newPasswordTextField.text, let phone = phoneTextField.text else {
            assertionFailure("colume is nil")
            return
        }
        
        if name.isEmpty || password.isEmpty || phone.isEmpty {
            print("空的")
            alert(message: "姓名或密碼或電話請勿空白")
            return
        }
        member?.name = name
        member?.password = password
        member?.phone = phone
        member?.sex = sex
        
        let endocer = JSONEncoder()
        guard let memberJson = try? endocer.encode(member) else {
            return
        }
        let memberString = String(data: memberJson, encoding: .utf8)
        var json = [String: Any]()
        json["action"] = MemberAction.MemberUpdate.rawValue
        json["member"] = memberString
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            assertionFailure("Parse JSON Fail!")
            return
        }
        memberAPI.doPost(url: MEMBER_URL, data: jsonData) { (error, data) in
            if let error = error {
                print("\(error)")
                return
            }
            
            guard let data = data, let dataString = String(data: data, encoding: .utf8) else {
                assertionFailure("Data is nil")
                return
            }
            
            // 如果傳回1表示更新成功
            if dataString == "1" {
                self.dismiss(animated: true, completion: nil)
            } else {
                let controller = UIAlertController(title: "提示", message: "更新失敗!!", preferredStyle: .alert)
                let action = UIAlertAction(title: "確定", style: .default)
                controller.addAction(action)
                self.present(controller, animated: true)
            }
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        bottonConstraint.constant = 55
        imageView.isHidden = false
        return true
    }
    

    // 當鍵盤即將升起時會執行方法
    
    @objc func moveTextFieldUp(aNotification:Notification){
//        imageView.isHidden = true
        // 取出詳情
        let info = aNotification.userInfo
        // 取出尺寸值
        let sizeValue = info![UIKeyboardFrameEndUserInfoKey] as!
        NSValue
        
        // 將尺寸值轉換為CGSize
        let size = sizeValue.cgRectValue.size
        // 拿出高度
        let height = size.height
        // 把底部距離改為0
        self.bottonConstraint.constant = +height
        // 利用動畫增加延遲感
        UIView.animate(withDuration: 0.25){
            self.view.layoutIfNeeded()
        }
    }
    func alert(message: String){
        let controller = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "確定", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
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
