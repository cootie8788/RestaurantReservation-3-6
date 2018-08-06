//
//  LoginViewController.swift
//  RestaurantReservation
//
//  Created by user on 2018/7/22.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit
import Starscream

var commonWebSocketClient: CommonWebSocketClient?

class LoginViewController: UIViewController, UITextFieldDelegate {
    
//    let loginAPI = LoginAPI(url: http://10.0.2.2:8080/RestaurantReservationApp_Web/MemberServlet)
    @IBOutlet weak var emailTextFiedl: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let memberAPI = MemberAPI()
    let userDeafult = UserDefaults.standard
    
    let socket = SocketClient.chatWebSocketClient
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ordertest = ""
        
        emailTextFiedl.delegate = self
        passwordTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        guard let email = emailTextFiedl.text , let password = passwordTextField.text else {
            assertionFailure("Email or Password is nil")
            return
        }
        let json: [String: Any] = ["action": MemberAction.IsUserValid.rawValue, "email": email, "password": password]
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
                assertionFailure("Data is nil")
                return
            }
            let decoder = JSONDecoder()
            guard let login = try? decoder.decode(Login.self, from: data) else {
                assertionFailure("Decoder Fail!")
                return
            }
            if login.isUserValid {
                print("登入成功")
                
                commonWebSocketClient = CommonWebSocketClient(url: "http://127.0.0.1:8080/RestaurantReservationApp_Web/CheckOrderWebSocket/\(login.memberName)")
                commonWebSocketClient?.startWebSocket()
                guard let controller = self.getController(authority_id: login.authority_id) else {
                    assertionFailure("controller is nil")
                    return
                }
                if self.socket.socket.delegate == nil{
                    print("socket 連線")
                    self.socket.startLinkServer()
                }
                self.userDeafult.removeObject(forKey: MemberKey.TableNumber.rawValue)
                self.userDeafult.removeObject(forKey: "person")
                self.userDeafult.removeObject(forKey: "date")
                
                self.userDeafult.set(login.memberId, forKey: MemberKey.MemberID.rawValue)
                self.userDeafult.set(login.authority_id, forKey: MemberKey.Authority_id.rawValue)
                self.userDeafult.set(login.memberName, forKey: MemberKey.MemberName.rawValue)
                self.present(controller, animated: true)
            } else {
                let controller = UIAlertController(title: "警告", message: "帳號密碼錯誤", preferredStyle: .alert)
                let action = UIAlertAction(title: "確定", style: .default)
                controller.addAction(action)
                self.present(controller, animated: true)
            }
        }
    }
    
    func getController(authority_id: Int) -> UIViewController? {
        var controller = UIViewController()
        switch authority_id {
        case 1:
            if let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "MainStoryboard") {
                controller = storyboard
            }
        case 2:
            controller = UIViewController()
        case 3:
            if let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "SecondStoryboard") as? UITabBarController {
                controller = storyboard
            }
        case 4:
            if let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "thirdStoryboard") {
                controller = storyboard
            }
        default:
            controller = UIViewController()
        }
        
        return controller
    }
    
    @IBAction func logout(sender: UIStoryboardSegue) {
        // 清空userDeafult的memberId
        userDeafult.removeObject(forKey: MemberKey.MemberID.rawValue)
        userDeafult.removeObject(forKey: MemberKey.MemberName.rawValue)
        
        emailTextFiedl.text = ""
        passwordTextField.text = ""
        commonWebSocketClient?.stopWebSocket()
    }
    
    // 點return就收鍵盤
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 點背景收鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
