//
//  ForgetPasswordTVC.swift
//  StartUp
//
//  Created by Saleh  on 31/1/17.
//  Copyright © 2017 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit

class ForgetPasswordTVC: UITableViewController {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.navigationController?.navigationBarHidden = true
        self.title = "Forget Password"
        setUpUI()
        
    }
    
    func setUpUI()
    {
        self.tableView.separatorColor = UIColor.clear
        
        self.emailContainerView.layer.cornerRadius = 2.0
        self.emailContainerView.layer.borderColor = UIColor.lightGray.cgColor
        self.emailContainerView.layer.borderWidth = 1.0
        
        self.sendButton.layer.cornerRadius = 2.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        print("send button pressed")
    }
    
    //

}
