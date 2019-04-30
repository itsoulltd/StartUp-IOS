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
    
    var signInCheckStack: TransactionStack?
    
    func isSignedIn(onCompletion: ((Bool) -> Void) ) -> Void {
        
        if let request = ServiceBroker.defaultFactory().request(forKey: "IsSignedIn", classType: WebRequest.self){
            request.addAuth()
            signInCheckStack = TransactionStack(callBack: { (objs) in
                print(objs)
            })
            let transaction = Transaction(request: request, parserType: Response.self)
            signInCheckStack?.push(transaction)
            signInCheckStack?.commit()
        }
        else{
            onCompletion(false)
        }
    }
    
    fileprivate var loginStack: TransactionStack?
    private func createLoginStack(_ form: LoginForm, onCompletion: @escaping (AfterLogin?) -> Void) -> TransactionStack{
        return TransactionStack(callBack: {(received) in
            if let loginResponse = received?.first as? AfterLogin{
                let management: UserManagement = AppRouter.shared().getAccount()
                let _ = management.loginWithToken(loginResponse.id_token! as String
                    , email: form.username! as String
                    , password: form.password! as String
                    , remembered: form.rememberMe.boolValue)
                let profile = UserProfile()
                profile.userName = form.username
                //TODO:
                management.profile = profile
                onCompletion(loginResponse)
            }else{
                onCompletion(nil)
            }
        })
    }
    
    func login(_ form: LoginForm, onCompletion: @escaping (AfterLogin?) -> Void) {
        guard let request = ServiceBroker.defaultFactory().request(forKey: "SignIn", classType: WebRequest.self) else{
            fatalError("Login not found")
        }
        request.payLoad = form
        loginStack = createLoginStack(form, onCompletion: onCompletion)
        let process = Transaction(request: request, parserType: AfterLogin.self)
        loginStack?.push(process)
        loginStack?.commit()
    }
    
    fileprivate var contactUsStack: TransactionStack?
    func contactUs(_ contactUs: ContactUsForm, onComplete: @escaping ((ContactUs?) -> Void)) -> Void{
        
        guard let request = ServiceBroker.defaultFactory().request(forKey: "ContactUs", classType: WebRequest.self) else{
            fatalError("ContactUs not found")
        }
        
        request.addAuth()
        request.payLoad = contactUs
        
        contactUsStack = TransactionStack(callBack: { (received) in
            guard let contactUsRes = received?.first as? ContactUs else{
                onComplete(nil)
                return
            }
            onComplete(contactUsRes)
        })
        
        let process = Transaction(request: request, parserType: ContactUs.self)
        self.contactUsStack?.push(process)
        self.contactUsStack?.commit()
    }
    
    private var registrationStack: TransactionStack?
    
    func register(form: RegistrationForm, onCompletion: ((AfterRegistration?) -> Void)) -> Void {
        guard let request = ServiceBroker.defaultFactory().request(forKey: "SignUp") else {
            fatalError("Registration Not Found")
        }
        
        request.payLoad = form
        registrationStack = TransactionStack(callBack: { (responses) in
            //TODO
        })
        let trans = Transaction(request: request, parserType: AfterRegistration.self)
        registrationStack?.push(trans)
        registrationStack?.commit()
    }
    
    private var forgotPassStack: TransactionStack?
    
    func forgotPassword(email: String, onCompletion: ((Bool) -> Void)) -> Void {
        guard let request = ServiceBroker.defaultFactory().request(forKey: "ForgotPassword") else {
            fatalError("Registration Not Found")
        }
        
        request.payLoad = NGObject(info: ["email":email])
        forgotPassStack = TransactionStack(callBack: { (responses) in
            //TODO
        })
        let trans = Transaction(request: request, parserType: Response.self)
        forgotPassStack?.push(trans)
        forgotPassStack?.commit()
    }
    
    private var changePassStack: TransactionStack?
    
    func changePassword(form: ChangePassForm, onCompletion: ((Bool) -> Void)) -> Void {
        guard let request = ServiceBroker.defaultFactory().request(forKey: "ChangePassword") else {
            fatalError("Registration Not Found")
        }
        
        request.payLoad = form
        changePassStack = TransactionStack(callBack: { (responses) in
            //TODO
        })
        let trans = Transaction(request: request, parserType: Response.self)
        changePassStack?.push(trans)
        changePassStack?.commit()
    }
    
}
