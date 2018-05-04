//
//  User.swift
//  StartUp
//
//  Created by Towhid Islam on 10/30/16.
//  Copyright © 2018 ITSoulLab (https://www.itsoullab.com). All rights reserved.
//

import UIKit
import CoreDataStack
import CoreNetworkStack
import WebServiceKit
import NGAppKit

enum UserError: Error {
    case unauthrize
    case serviceNotFound
}

class User: NGObject {
    
    lazy var management: UserManagement = AppRouter.shared().getAccount()
    var profile: UserProfile? {
        return management.profile as? UserProfile
    }
    
    var signedIn: TransactionStack?
    
    func isSignedIn(onCompletion: ((Bool) -> Void) ) -> Void {
        
        if let request = ServiceBroker.defaultFactory().request(forKey: "IsSignedIn", classType: DNXRequest.self){
            request.addAuth()
            signedIn = TransactionStack(callBack: { (objs) in
                print(objs)
            })
            let transaction = Transaction(request: request, parserType: Response.self)
            signedIn?.push(transaction)
            signedIn?.commit()
        }
        else{
            onCompletion(false)
        }
    }
    
    var transaction: TransactionStack?
    
    func login(_ form: LoginForm, onCompletion: @escaping (AfterLogin?) -> Void) {
        
        guard let request = ServiceBroker.defaultFactory().request(forKey: "SignIn", classType: DNXRequest.self) else{
            fatalError("Login not found")
        }
        
        request.payLoad = form
        transaction = TransactionStack(callBack: {[weak self] (received) in
            if let loginResponse = received?.first as? AfterLogin{
                let _ = self?.management.loginWithToken(loginResponse.id_token! as String
                    , email: form.username! as String
                    , password: form.password! as String
                    , remembered: form.rememberMe.boolValue)
                let profile = UserProfile()
                profile.userName = form.username
                //TODO:
                self?.management.profile = profile
                onCompletion(loginResponse)
            }else{
                onCompletion(nil)
            }
        })
        let process = Transaction(request: request, parserType: AfterLogin.self)
        transaction?.push(process)
        transaction?.commit()
    }
    
    fileprivate var helpTrans: TransactionStack?
    func rokomaryHelp(_ contactUs: ContactUsForm, onComplete: @escaping ((ContactUs?) -> Void)) -> Void{
        
        guard let request = ServiceBroker.defaultFactory().request(forKey: "ContactUs", classType: DNXRequest.self) else{
            fatalError("ContactUs not found")
        }
        
        request.addAuth()
        request.payLoad = contactUs
        
        helpTrans = TransactionStack(callBack: { (received) in
            guard let contactUsRes = received?.first as? ContactUs else{
                onComplete(nil)
                return
            }
            onComplete(contactUsRes)
        })
        
        let process = Transaction(request: request, parserType: ContactUs.self)
        self.helpTrans?.push(process)
        self.helpTrans?.commit()
    }
    
    private var register: TransactionStack?
    
    func register(form: RegistrationForm, onCompletion: ((AfterRegistration?) -> Void)) -> Void {
        guard let request = ServiceBroker.defaultFactory().request(forKey: "SignUp") else {
            fatalError("Registration Not Found")
        }
        
        request.payLoad = form
        register = TransactionStack(callBack: { (responses) in
            //TODO
        })
        let trans = Transaction(request: request, parserType: AfterRegistration.self)
        register?.push(trans)
        register?.commit()
    }
    
    private var forgot: TransactionStack?
    
    func forgotPassword(email: String, onCompletion: ((Bool) -> Void)) -> Void {
        guard let request = ServiceBroker.defaultFactory().request(forKey: "ForgotPassword") else {
            fatalError("Registration Not Found")
        }
        
        request.payLoad = NGObject(info: ["email":email])
        forgot = TransactionStack(callBack: { (responses) in
            //TODO
        })
        let trans = Transaction(request: request, parserType: Response.self)
        forgot?.push(trans)
        forgot?.commit()
    }
    
    private var changePass: TransactionStack?
    
    func changePassword(form: ChangePassForm, onCompletion: ((Bool) -> Void)) -> Void {
        guard let request = ServiceBroker.defaultFactory().request(forKey: "ChangePassword") else {
            fatalError("Registration Not Found")
        }
        
        request.payLoad = form
        changePass = TransactionStack(callBack: { (responses) in
            //TODO
        })
        let trans = Transaction(request: request, parserType: Response.self)
        changePass?.push(trans)
        changePass?.commit()
    }
    
}
