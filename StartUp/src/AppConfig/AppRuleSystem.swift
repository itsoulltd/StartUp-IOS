//
//  AppRuleSystem.swift
//  HoxroCaseTracker
//
//  Created by Towhid Islam on 10/7/16.
//  Copyright © 2016 Hoxro Limited, 207 Regent Street, London, W1B 3HN London. All rights reserved.
//

import UIKit
import CoreDataStack
import CoreNetworkStack
import WebServiceKit
import NGAppKit

class AppRuleSystem: NSObject {
    
    struct Fact {
        static let EmailValue = "email"
        static let PasswordValue = "password"
        static let PasswordConfirmValue = "password_confirm"
        static let FormTextInput = "FormFieldInput"
        static let FormTextInputConfirm = "ConfirmFieldInput"
    }

    class func allPassRuleSystem() -> NGRuleSystem{
        return NGRuleSystem()
    }
    
    class func addRequiredRule(_ ruleSystem: inout NGRuleSystem, forFact fact: String){
        let _ = ruleSystem.addRule(NGRule(condition: { (system: NGRuleSystem) -> Bool in
            let input = system.state(fact) as! String
            return (input.count <= 0)
            }, assertion: { (system: NGRuleSystem) -> Void in
                system.assert ( Fact.FormTextInput, grade: 1.0, message: "\(fact) \(FormValidationError.RequiredMessage)")
        }))
    }
    
    class func addLengthRule(_ ruleSystem: inout NGRuleSystem, forFact fact: String, length: Length){
        let _ = ruleSystem.addRule(NGRule(condition: { (system: NGRuleSystem) -> Bool in
            let input = system.state(fact) as! String
            return length.validate(input.count as AnyObject) == false
            }, assertion: { (system: NGRuleSystem) -> Void in
                system.assert ( Fact.FormTextInput, grade: 1.0, message: "\(fact) \(FormValidationError.LengthMessage) \(length.targetLength)")
        }))
    }
    
    class func addRegXRule(_ ruleSystem: inout NGRuleSystem, forFact fact: String, regX: RegX){
        let _ = ruleSystem.addRule(NGRule(condition: { (system: NGRuleSystem) -> Bool in
            let input = system.state(fact) as! String
            return regX.validate(input as AnyObject) == false
            }, assertion: { (system) -> Void in
                system.assert ( Fact.FormTextInput, grade: 1.0, message: "\(fact) \(FormValidationError.PatternMessage)")
        }))
    }
    
    class func MobileNumber() -> NGRuleSystem {
        let rules = NGRuleSystem()
        //Length Validation
        let _ = rules.addRule(NGRule(condition: { (system) -> Bool in
            let input = system.state(Fact.FormTextInput) as! String
            let length = Length(length: FormValidationConstants.MobileNumberMinLength, relation: RelationalOperator.minOrEqual)
            let result = length.validate(input.count as AnyObject) == false
            return result
            }, assertion: { (system) in
                system.assert ( Fact.FormTextInput, grade: 1.0, message: "\(FormPropertyKeys.PhoneNumber) \(FormValidationError.LengthMessage) \(FormValidationConstants.MobileNumberMinLength)")
        }))
        //Format RegX Validation
        let _ = rules.addRule(NGRule(condition: { (system) -> Bool in
            let input = system.state(Fact.FormTextInput) as! String
            let regX = RegX(pattern: FormValidationConstants.MobileNumberRegX)
            let result = regX.validate(input as AnyObject) == false
            return result
            }, assertion: { (system) in
                system.assert ( Fact.FormTextInput, grade: 1.0, message: "\(FormValidationError.MobileNumberInvalidMessage)")
        }))
        return rules
    }
    
    class func UserName() -> NGRuleSystem{
        let unRuleSystem = NGRuleSystem()
        let _ = unRuleSystem.addRule(NGRule(condition: { (system: NGRuleSystem) -> Bool in
            let input = system.state(Fact.FormTextInput) as! String
            let length = Length(length: FormValidationConstants.UserNameMinLength, relation: RelationalOperator.maxOrEqual)
            return length.validate(input.count as AnyObject) == false
            }, assertion: { (system: NGRuleSystem) -> Void in
                system.assert ( Fact.FormTextInput, grade: 1.0, message: "\(FormPropertyKeys.UserName) \(FormValidationError.LengthMessage) \(FormValidationConstants.UserNameMinLength)")
        }))
        let _ = unRuleSystem.addRule(NGRule(condition: { (system: NGRuleSystem) -> Bool in
            //this field is required
            let input = system.state(Fact.FormTextInput) as! String
            return (input.count <= 0)
            }, assertion: { (system: NGRuleSystem) -> Void in
                system.assert ( Fact.FormTextInput, grade: 1.0, message: "\(FormPropertyKeys.UserName) \(FormValidationError.RequiredMessage)")
        }))
        return unRuleSystem
    }
    
    class func Email() -> NGRuleSystem{
        let emailRuleSystem = NGRuleSystem()
        let _ = emailRuleSystem.addRule(NGRule(condition: { (system: NGRuleSystem) -> Bool in
            let input = system.state(Fact.EmailValue) as! String
            let regX = RegX(pattern: FormValidationConstants.EmailRegX2)
            return regX.validate(input as AnyObject) == false
            }, assertion: { (system) -> Void in
                system.assert ( Fact.EmailValue, grade: 1.0, message: "")
        }))
        let _ = emailRuleSystem.addRule(NGRule(condition: { (system: NGRuleSystem) -> Bool in
            //this field is required
            let input = system.state(Fact.EmailValue) as! String
            return (input.count <= 0)
            }, assertion: { (system: NGRuleSystem) -> Void in
                system.assert ( Fact.EmailValue, grade: 1.0, message: "")
        }))
        return emailRuleSystem
    }
    
    class func Password() -> NGRuleSystem{
        let passRuleSystem = NGRuleSystem()
        let _ = passRuleSystem.addRule(NGRule(condition: { (system: NGRuleSystem) -> Bool in
            let input = system.state(Fact.PasswordValue) as! String
            let length = Length(length: FormValidationConstants.PasswordMinLength, relation: RelationalOperator.maxOrEqual)
            return length.validate(input.count as AnyObject) == false
            }, assertion: { (system) -> Void in
                system.assert ( Fact.PasswordValue, grade: 1.0, message: "\(FormPropertyKeys.Password) \(FormValidationError.LengthMessage) \(FormValidationConstants.PasswordMinLength)")
        }))
        let _ = passRuleSystem.addRule(NGRule(condition: { (system: NGRuleSystem) -> Bool in
            let input = system.state(Fact.PasswordValue) as! String
            let regX = RegX(pattern: FormValidationConstants.PasswordRegX2)
            return regX.validate(input as AnyObject) == false
            }, assertion: { (system) -> Void in
                system.assert ( Fact.PasswordValue, grade: 1.0, message: "\(FormPropertyKeys.Password) \(FormValidationError.PasswordInvalidMessage)")
        }))
        let _ = passRuleSystem.addRule(NGRule(condition: { (system: NGRuleSystem) -> Bool in
            //this field is required
            let input = system.state(Fact.PasswordValue) as! String
            return (input.count <= 0)
            }, assertion: { (system: NGRuleSystem) -> Void in
                system.assert ( Fact.PasswordValue, grade: 1.0, message: "\(FormPropertyKeys.Password) \(FormValidationError.RequiredMessage)")
        }))
        return passRuleSystem
    }
    
    class func ConfirmPassword(_ existingRule: inout NGRuleSystem){
        let _ = existingRule.addRule(NGRule(condition: { (system: NGRuleSystem) -> Bool in
            let password = system.state(Fact.PasswordConfirmValue) as! String
            if let confirm = system.state(Fact.FormTextInputConfirm) as? String{
                return (password != confirm)
            }
            return true
            }, assertion: { (system: NGRuleSystem) -> Void in
                system.assert ( Fact.PasswordConfirmValue, grade: 1.0, message: "\(FormPropertyKeys.ConfirmPassword) \(FormValidationError.PasswordMissmatchMessage)")
        }))
    }
    
}
