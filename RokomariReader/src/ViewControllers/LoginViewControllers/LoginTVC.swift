//
//  LoginTVC.swift
//  RokomariReader
//
//  Created by Saleh  on 17/12/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit

class LoginTVC: UITableViewController {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.navigationController?.navigationBarHidden = true
        setUpUI()
        
    }
    
    func setUpUI()
    {
        self.tableView.separatorColor = UIColor.clearColor()
        
        self.emailContainerView.layer.cornerRadius = 2.0
        self.emailContainerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.emailContainerView.layer.borderWidth = 1.0
        
        self.passwordContainerView.layer.cornerRadius = 2.0
        self.passwordContainerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.passwordContainerView.layer.borderWidth = 1.0
        
        self.signInButton.layer.cornerRadius = 2.0
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonAction(sender: UIButton) {
        print("sign in button tapped")
        
    }
    
    @IBAction func forgetPasswordButtonAction(sender: AnyObject) {
        print("forget password button tapped")
        
    }
    
    @IBAction func facebookButtonAction(sender: AnyObject) {
        print("facebook button tapped")
        
    }
    
    @IBAction func gmailButtonAction(sender: AnyObject) {
        print("gmial button tapped")
        
    }

    @IBAction func signUpButtonAction(sender: AnyObject) {
        print("signup button tapped")
        
    }
//
    
}
