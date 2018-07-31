//
//  RegisterViewController.swift
//  RestaurantReservation
//
//  Created by user on 2018/7/23.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, SSRadioButtonControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var againPasswordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    let alertTitle = "提示"
    
    var radioButtonController: SSRadioButtonsController?
    var sex = 1
    
    let memberAPI = MemberAPI()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 註冊（我在意鍵盤即將升起）的通知
        NotificationCenter.default.addObserver(self, selector:#selector(moveTextFieldUp(aNotification:)),name: .UIKeyboardWillShow, object:nil)
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        againPasswordTextField.delegate = self
        phoneTextField.delegate = self
        
        
        // 設定單選
        radioButtonController = SSRadioButtonsController(buttons: manButton,womanButton)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        // Set radio button deafult
        radioButtonController?.pressed(manButton)
        
        // 設定TextField的底線
        nameTextField.setBottomBorder()
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        againPasswordTextField.setBottomBorder()
        phoneTextField.setBottomBorder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 選擇單選按鈕時會呼叫
    func didSelectButton(selectedButton: UIButton?) {
        //        print("\(String(describing: selectedButton))")
        if selectedButton == manButton {
            sex = 1
        } else {
            sex = 2
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        bottonConstraint.constant = 100
        return true
    }
    
    // 當鍵盤即將升起時會執行方法
  @objc func moveTextFieldUp(aNotification:Notification){
        //取出詳情
        let info = aNotification.userInfo
        // 取出尺寸值
        let sizeValue = info![UIKeyboardFrameEndUserInfoKey] as!
        NSValue
        
        // 將尺寸值轉換為CGSize
        let size = sizeValue.cgRectValue.size
        //拿出高度
        let height = size.height
        // 把底部距離改為0
        self.bottonConstraint.constant = +height
        // 利用動畫增加延遲感
        UIView.animate(withDuration: 0.25){
            self.view.layoutIfNeeded()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func registerBtnPressed(_ sender: Any) {
        
        guard  let name = nameTextField.text, let phone = phoneTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            assertionFailure("nil")
            return
        }
        let member = Member(id: 0, name: name, sex: sex, phone: phone, email: email, password: password)
        let endocer = JSONEncoder()
        guard let memberJson = try? endocer.encode(member) else {
            return
        }
        let memberString = String(data: memberJson, encoding: .utf8)
        var json = [String:Any]()
        json["action"] = MemberAction.MemberInsert.rawValue
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
            guard let data = data else {
                print("Data is nil")
                return
            }
            guard let register = String(data: data, encoding: .utf8) else {
                print("String encoding is Fail!")
                return
            }
            if register == "1" {
                self.simpleAlert(message: "註冊成功", completion: {_ in
                    // 返回上一頁
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                print("註冊失敗")
                self.simpleAlert(message: "帳號已有人使用！！", completion: nil)
            }
        }
        
    }
    
    func simpleAlert(message: String, completion: ((UIAlertAction) -> Void)?) {
        let controller = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "確定", style: .default, handler: completion)
        controller.addAction(action)
        present(controller, animated: true)
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
}
