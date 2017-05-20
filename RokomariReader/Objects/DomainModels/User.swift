//
//  User.swift
//  RokomariReader
//
//  Created by Towhid Islam on 10/30/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import CoreDataStack
import CoreNetworkStack
import WebServiceKit

enum UserError: Error {
    case unauthrize
    case serviceNotFound
}

class User: NGObject {
    
    lazy var management: UserManagement = UserManagement(profileType: UserProfile.self)
    var profile: UserProfile? {
        return management.profile as? UserProfile
    }
    
    var transaction: TransactionStack?
    
    func login(_ form: LoginForm, onCompletion: @escaping (AfterLogin?) -> Void) {
        if let request = ServiceBroker.defaultFactory().request(forKey: "SignIn") as? DNXRequest{
            request.payLoad = form
            if transaction == nil {
                transaction = TransactionStack(callBack: {[weak self] (received) in
                    if let loginResponse = received?.first as? AfterLogin{
                        let _ = self?.management.loginWithToken(loginResponse.id_token as! String, email: form.username as! String, password: form.password as! String, remembered: form.rememberMe.boolValue)
                        let profile = UserProfile()
                        profile.userName = form.username
                        //TODO:
                        self?.management.profile = profile
                        onCompletion(loginResponse)
                    }else{
                        if let ponse = received?.first as? Response{
                            print(ponse.errorMessage!)
                        }
                        onCompletion(nil)
                    }
                    self?.transaction = nil
                })
            }
            let process = Transaction(request: request, parserType: AfterLogin.self)
            transaction?.push(process)
            transaction?.commit()
        }
    }
    
    fileprivate var helpTrans: TransactionStack?
    func rokomaryHelp(_ contactUs: ContactUsForm, onComplete: @escaping ((ContactUs?) -> Void)) -> Void{
        
        guard let request = ServiceBroker.defaultFactory().request(forKey: "ContactUs") else{
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
    
}
