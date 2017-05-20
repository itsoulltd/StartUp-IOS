//
//  RegistrationTVC.swift
//  RokomariReader
//
//  Created by Saleh  on 31/1/17.
//  Copyright © 2017 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit

class RegistrationTVC: UITableViewController {

    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    //
    @IBOutlet weak var fullNameContainerView: UIView!
    @IBOutlet weak var phoneContainerView: UIView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var maleSwitch: UISwitch!
    @IBOutlet weak var femaleSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationController?.navigationBarHidden = true
        self.title = "Sign Up"
        setUpUI()
        
    }
    
    func setUpUI()
    {
        self.tableView.separatorColor = UIColor.clear
        
        self.emailContainerView.layer.cornerRadius = 2.0
        self.emailContainerView.layer.borderColor = UIColor.lightGray.cgColor
        self.emailContainerView.layer.borderWidth = 1.0
        
        self.passwordContainerView.layer.cornerRadius = 2.0
        self.passwordContainerView.layer.borderColor = UIColor.lightGray.cgColor
        self.passwordContainerView.layer.borderWidth = 1.0
        
        self.fullNameContainerView.layer.cornerRadius = 2.0
        self.fullNameContainerView.layer.borderColor = UIColor.lightGray.cgColor
        self.fullNameContainerView.layer.borderWidth = 1.0
        
        self.phoneContainerView.layer.cornerRadius = 2.0
        self.phoneContainerView.layer.borderColor = UIColor.lightGray.cgColor
        self.phoneContainerView.layer.borderWidth = 1.0
        
        self.signUpButton.layer.cornerRadius = 2.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func facebookButtonAction(_ sender: AnyObject) {
        print("facebook button tapped")
        
    }
    
    @IBAction func gmailButtonAction(_ sender: AnyObject) {
        print("gmial button tapped")
        
    }
    
    @IBAction func signUpButtonAction(_ sender: AnyObject) {
        print("signup button tapped")
        
    }
    //
    
    @IBAction func maleSwitchAction(_ sender: AnyObject) {
        print("male switch pressed")
    }
    
    @IBAction func femaleSwitchAction(_ sender: AnyObject) {
        print("female switch pressed")
    }
    

}
