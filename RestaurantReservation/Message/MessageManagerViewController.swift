//
//  MessageManagerViewController.swift
//  RestaurantReservation
//
//  Created by Jim on 2018/7/31.
//  Copyright © 2018年 Peggy Tsai. All rights reserved.
//

import UIKit

class MessageManagerViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var messageNewTitleTextField: UITextField!
    @IBOutlet weak var messageNewStartTextField: UITextField!
    @IBOutlet weak var messageNewEndTextField: UITextField!
    @IBOutlet weak var messageNewDiscountTextField: UITextField!
    @IBOutlet weak var messageNewContentTextField: UITextField!
    @IBOutlet weak var messageNewImageView: UIImageView!
    
    
    var radioButtonController: SSRadioButtonsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messageNewImageView.image = #imageLiteral(resourceName: "pic_pot")
        messageNewTitleTextField.setBottomBorder()
        messageNewStartTextField.setBottomBorder()
        messageNewEndTextField.setBottomBorder()
        messageNewDiscountTextField.setBottomBorder()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func messageAddImageBtnPress(_ sender: Any) {
        
    }
    

}
