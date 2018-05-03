//
//  LoginTVC.swift
//  RokomariReader
//
//  Created by Saleh  on 17/12/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import MBProgressHUD
import WebServiceKit
import UIView_Shake
import NGAppKit

class LoginTVC: UITableViewController {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    private let user: User = User()
    private let emailRuleSystem = NGRuleSystem()
    private let passRuleSystem = NGRuleSystem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.navigationController?.navigationBarHidden = true
        self.title = "Sign In"
        setUpUI()
        setUpRules()
    }
    
    func setUpUI()
    {
        
        let user: UserProfile? = AppRouter.shared().getAccount().profile as? UserProfile
        
        self.tableView.separatorColor = UIColor.clear
        
        self.emailTextField.keyboardType = UIKeyboardType.emailAddress
        self.emailTextField.delegate = self
        self.emailContainerView.layer.cornerRadius = 2.0
        self.emailContainerView.layer.borderColor = UIColor.lightGray.cgColor
        self.emailContainerView.layer.borderWidth = 1.0
        if user != nil && user?.email != nil {
            self.emailTextField.text = user?.email as String?
        }
        
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.delegate = self;
        self.passwordContainerView.layer.cornerRadius = 2.0
        self.passwordContainerView.layer.borderColor = UIColor.lightGray.cgColor
        self.passwordContainerView.layer.borderWidth = 1.0
        self.passwordTextField.returnKeyType = UIReturnKeyType.go
        
        self.signInButton.layer.cornerRadius = 2.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpRules() {
        //Email Rules
        /*let _ = emailRuleSystem.addRule(NGRule(condition: { (system: NGRuleSystem) -> Bool in
            let input = system.state(AppRuleSystem.Fact.EmailValue) as! String
            let regX = RegX(pattern: FormValidationConstants.EmailRegX2)
            return regX.validate(input as AnyObject) == false
        }, assertion: { (system) -> Void in
            system.assert ( AppRuleSystem.Fact.EmailValue, grade: 1.0, message: "\(AppRuleSystem.Fact.EmailValue) \(FormValidationError.PatternMessage)")
        }))*/
        //
        let _ = emailRuleSystem.addRule(NGRule(condition: { (system: NGRuleSystem) -> Bool in
            let input = system.state(AppRuleSystem.Fact.EmailValue) as! String
            return (input.count <= 0)
        }, assertion: { (system: NGRuleSystem) -> Void in
            system.assert ( AppRuleSystem.Fact.EmailValue, grade: 1.0, message: "\(AppRuleSystem.Fact.EmailValue) \(FormValidationError.RequiredMessage)")
        }))
        //Password Rules
        let _ = passRuleSystem.addRule(NGRule(condition: { (system: NGRuleSystem) -> Bool in
            let input = system.state(AppRuleSystem.Fact.PasswordValue) as! String
            let length = Length(length: FormValidationConstants.PasswordMinLength, relation: RelationalOperator.maxOrEqual)
            return length.validate(input.count as AnyObject) == false
        }, assertion: { (system) -> Void in
            system.assert ( AppRuleSystem.Fact.PasswordValue, grade: 1.0, message: "\(FormValidationError.LengthMessage) \(FormValidationConstants.PasswordMinLength)")
        }))
        //
        let _ = passRuleSystem.addRule(NGRule(condition: { (system: NGRuleSystem) -> Bool in
            let input = system.state(AppRuleSystem.Fact.PasswordValue) as! String
            return (input.count <= 0)
        }, assertion: { (system: NGRuleSystem) -> Void in
            system.assert ( AppRuleSystem.Fact.PasswordValue, grade: 1.0, message: "\(AppRuleSystem.Fact.PasswordValue) \(FormValidationError.RequiredMessage)")
        }))
    }
    
    private func validateInputData(_ email: String, pass: String) -> LoginForm? {
        
        emailRuleSystem.resetSystem()
        emailRuleSystem.setState(AppRuleSystem.Fact.EmailValue, value: (email as AnyObject))
        
        passRuleSystem.resetSystem()
        passRuleSystem.setState(AppRuleSystem.Fact.PasswordValue, value: (pass as AnyObject))
        
        emailRuleSystem.evaluateSystem()
        if emailRuleSystem.satisfied(AppRuleSystem.Fact.EmailValue) == true {
            emailTextField.shake()
            return nil
        }
        
        passRuleSystem.evaluateSystem()
        if passRuleSystem.satisfied(AppRuleSystem.Fact.PasswordValue) == true {
            passwordTextField.shake()
            return nil
        }
        
        let form = LoginForm()
        form.username = email as NSString     // For test "admin"
        form.password = pass as NSString     //"admin"
        return form
    }
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        print("sign in button tapped")
        //
        guard let email = emailTextField.text else {
            emailTextField.shake()
            return
        }
        guard let pass = passwordTextField.text else {
            passwordTextField.shake()
            return
        }
        
        guard let model = validateInputData(email, pass: pass) else {
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Please wait..."
        
        //
        self.user.login(model) { [weak self] (response) in
            MBProgressHUD.hide(for: (self?.view)!, animated: true)
            guard let parser = response else{
                let alert = AlertMessage()
                alert.title = "Login Failed!"
                alert.message = "Please Try again later."
                alert.cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
                MessageController.alert(alert)
                return
            }
            print(parser.serializeIntoInfo())//
            AppRouter.shared().start()
        }
    }
    
    @IBAction func forgetPasswordButtonAction(_ sender: AnyObject) {
        print("forget password button tapped")
        AppRouter.shared().show(fromType: ForgetPasswordTVC.self)
    }
    
    @IBAction func facebookButtonAction(_ sender: AnyObject) {
        print("facebook button tapped")
        
    }
    
    @IBAction func gmailButtonAction(_ sender: AnyObject) {
        print("gmial button tapped")
        
    }
    
    @IBAction func signUpButtonAction(_ sender: AnyObject) {
        print("SignUp button tapped")
        AppRouter.shared().show(fromType: RegistrationTVC.self)
    }
    
}

extension LoginTVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === self.emailTextField  {
            self.passwordTextField.becomeFirstResponder()
        }else if textField === self.passwordTextField{
            self.passwordTextField.resignFirstResponder()
            self.signInButton.sendActions(for: UIControlEvents.touchUpInside)
        }
        return true
    }
    
}
