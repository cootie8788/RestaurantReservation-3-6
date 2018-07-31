//
//  MemberViewController.swift
//  RestaurantReservation
//
//  Created by Peggy Tsai on 2018/7/13.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    let userDeafult = UserDefaults.standard
    let memberAPI = MemberAPI()
    
    var sex = ""
    
    var member: Member?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let memberID = userDeafult.string(forKey: MemberKey.MemberID.rawValue)
        let json: [String: Any] = ["action" : MemberAction.GetMemberData.rawValue, "memberId": memberID ?? -1]
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
            
            guard let member = try? decoder.decode(Member.self, from: data) else {
                assertionFailure("Decode error")
                return
            }
            
            if member.sex == 1 {
                self.sex = "先生"
            } else {
                self.sex = "小姐"
            }
            
            self.nameLabel.text = member.name
            self.emailLabel.text = member.email
            self.sexLabel.text = self.sex
            self.phoneLabel.text = member.phone
            self.member = member
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reviseBtnPressed(_ sender: Any) {
        // 生成NavigationController
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ReviseMember") as? UINavigationController else {
            assertionFailure("controller get fail!!")
            return
        }
        // 取得NavigationController連的第一個viewController
       let reviseController = controller.viewControllers.first as? MemberReviseViewController
        reviseController?.member = self.member
        present(controller, animated: true)
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
