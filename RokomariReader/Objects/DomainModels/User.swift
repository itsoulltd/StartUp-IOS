//
//  User.swift
//  RokomariReader
//
//  Created by Towhid Islam on 10/30/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

enum UserError: ErrorType {
    case Unauthrize
    case ServiceNotFound
}

class User: DNObject {
    
    lazy var management: UserManagement = UserManagement(profileType: UserProfile.self)
    var profile: UserProfile? {
        return management.profile as? UserProfile
    }
    
    var transaction: TransactionStack?
    
    func login(form: LoginForm, onCompletion: (AfterLogin?) -> Void) {
        if let request = RequestFactory.defaultFactory().request(forKey: "SignIn") as? DNXRequest{
            request.payLoad = form
            if transaction == nil {
                transaction = TransactionStack(callBack: {[weak self] (received) in
                    if let loginResponse = received?.first as? AfterLogin{
                        self?.management.loginWithToken(loginResponse.id_token as! String, email: form.username as! String, password: form.password as! String, remembered: form.rememberMe.boolValue)
                        let profile = UserProfile()
                        profile.userName = form.username
                        //TODO:
                        self?.management.profile = profile
                        onCompletion(loginResponse)
                    }else{
                        if let ponse = received?.first as? Response{
                            print(ponse.errorMessage)
                        }
                        onCompletion(nil)
                    }
                    self?.transaction = nil
                })
            }
            let process = TransactionProcess(request: request, parserType: AfterLogin.self)
            transaction?.push(process)
            transaction?.commit()
        }
    }
    
    private var helpTrans: TransactionStack?
    func rokomaryHelp(contactUs: ContactUsForm, onComplete: ((ContactUs?) -> Void)) -> Void{
        
        guard let request = RequestFactory.defaultFactory().request(forKey: "ContactUs") else{
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
        
        let process = TransactionProcess(request: request, parserType: ContactUs.self)
        self.helpTrans?.push(process)
        self.helpTrans?.commit()
    }
    
}
