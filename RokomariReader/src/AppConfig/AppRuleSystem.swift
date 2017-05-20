//
//  AppRuleSystem.swift
//  HoxroCaseTracker
//
//  Created by Towhid Islam on 10/7/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import CoreDataStack

struct AppValidationConstants {
    static let UserNameMinLength = 1
    static let PasswordMinLength = 5
    static let PasswordRegX = "((?=.*\\d)(?=.*[A-Za-z]).{6,20})"
    static let PasswordRegX2 = "^.*(?=.{8,})(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!*@#$%^&+=]).*$"
    static let EmailRegX = "[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}"
    static let EmailRegX2 = "\\A(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)\\Z"
    static let EmailMinLength = 7
    static let MobileNumberMinLength = 12
    static let MobileNumberRegX = ""
}

struct AppValidationError {
    static let RequiredMessage = NSLocalizedString("is a required field", comment: "")
    static let PatternMessage = NSLocalizedString("is invalid", comment: "")
    static let EmailInvalidMessage = NSLocalizedString("is invalid", comment: "")
    static let LengthMessage = NSLocalizedString("input length at least", comment: "")
    static let PasswordInvalidMessage = NSLocalizedString("is invalid", comment: "")
    static let PasswordMinLengthMessage = NSLocalizedString("minimum length is", comment: "")
    static let PasswordMissmatchMessage = NSLocalizedString("mismatch", comment: "")
    static let MobileNumberInvalidMessage = NSLocalizedString("is invalid", comment: "")
}

class AppRuleSystem: NSObject {
    
    struct Fact {
        static let Email = "Email"
        static let MobileNumber = "MobileNumber"
        static let UserName = "UserName"
        static let Password = "Password"
        static let PasswordConfirmation = "Confirm Password"
    }

    class func allPassRuleSystem() -> DNRuleSystem{
        return DNRuleSystem()
    }
    
    class func addRequiredRule(_ ruleSystem: inout DNRuleSystem, forFact fact: String){
        let _ = ruleSystem.addRule(DNRule(condition: { (system: DNRuleSystem) -> Bool in
            let input = system.state(fact) as! String
            return (input.characters.count <= 0)
            }, assertion: { (system: DNRuleSystem) -> Void in
                system.assert(fact: fact, grade: 1.0, message: "\(fact) \(AppValidationError.RequiredMessage)")
        }))
    }
    
    class func addLengthRule(_ ruleSystem: inout DNRuleSystem, forFact fact: String, length: Length){
        let _ = ruleSystem.addRule(DNRule(condition: { (system: DNRuleSystem) -> Bool in
            let input = system.state(fact) as! String
            return length.validate(input.characters.count as AnyObject) == false
            }, assertion: { (system: DNRuleSystem) -> Void in
                system.assert(fact: fact, grade: 1.0, message: "\(fact) \(AppValidationError.LengthMessage) \(length.targetLength)")
        }))
    }
    
    class func addRegXRule(_ ruleSystem: inout DNRuleSystem, forFact fact: String, regX: RegX){
        let _ = ruleSystem.addRule(DNRule(condition: { (system: DNRuleSystem) -> Bool in
            let input = system.state(fact) as! String
            return regX.validate(input as AnyObject) == false
            }, assertion: { (system) -> Void in
                system.assert(fact: fact, grade: 1.0, message: "\(fact) \(AppValidationError.PatternMessage)")
        }))
    }
    
    class func MobileNumber() -> DNRuleSystem {
        let rules = DNRuleSystem()
        //Length Validation
        let _ = rules.addRule(DNRule(condition: { (system) -> Bool in
            let input = system.state(Fact.MobileNumber) as! String
            let length = Length(length: AppValidationConstants.MobileNumberMinLength, relation: RelationalOperator.minOrEqual)
            let result = length.validate(input.characters.count as AnyObject) == false
            return result
            }, assertion: { (system) in
                system.assert(fact: Fact.MobileNumber, grade: 1.0, message: "\(Fact.MobileNumber) \(AppValidationError.LengthMessage) \(AppValidationConstants.MobileNumberMinLength)")
        }))
        //Format RegX Validation
        let _ = rules.addRule(DNRule(condition: { (system) -> Bool in
            let input = system.state(Fact.MobileNumber) as! String
            let regX = RegX(pattern: AppValidationConstants.MobileNumberRegX)
            let result = regX.validate(input as AnyObject) == false
            return result
            }, assertion: { (system) in
                system.assert(fact: Fact.MobileNumber, grade: 1.0, message: "\(AppValidationError.MobileNumberInvalidMessage)")
        }))
        return rules
    }
    
    class func UserName() -> DNRuleSystem{
        let unRuleSystem = DNRuleSystem()
        let _ = unRuleSystem.addRule(DNRule(condition: { (system: DNRuleSystem) -> Bool in
            let input = system.state(Fact.UserName) as! String
            let length = Length(length: AppValidationConstants.UserNameMinLength, relation: RelationalOperator.maxOrEqual)
            return length.validate(input.characters.count as AnyObject) == false
            }, assertion: { (system: DNRuleSystem) -> Void in
                system.assert(fact: Fact.UserName, grade: 1.0, message: "\(Fact.UserName) \(AppValidationError.LengthMessage) \(AppValidationConstants.UserNameMinLength)")
        }))
        let _ = unRuleSystem.addRule(DNRule(condition: { (system: DNRuleSystem) -> Bool in
            //this field is required
            let input = system.state(Fact.UserName) as! String
            return (input.characters.count <= 0)
            }, assertion: { (system: DNRuleSystem) -> Void in
                system.assert(fact: Fact.UserName, grade: 1.0, message: "\(Fact.UserName) \(AppValidationError.RequiredMessage)")
        }))
        return unRuleSystem
    }
    
    class func Email() -> DNRuleSystem{
        let emailRuleSystem = DNRuleSystem()
        let _ = emailRuleSystem.addRule(DNRule(condition: { (system: DNRuleSystem) -> Bool in
            let input = system.state(Fact.Email) as! String
            let regX = RegX(pattern: AppValidationConstants.EmailRegX2)
            return regX.validate(input as AnyObject) == false
            }, assertion: { (system) -> Void in
                system.assert(fact: Fact.Email, grade: 1.0, message: "")
        }))
        let _ = emailRuleSystem.addRule(DNRule(condition: { (system: DNRuleSystem) -> Bool in
            //this field is required
            let input = system.state(Fact.Email) as! String
            return (input.characters.count <= 0)
            }, assertion: { (system: DNRuleSystem) -> Void in
                system.assert(fact: Fact.Email, grade: 1.0, message: "")
        }))
        return emailRuleSystem
    }
    
    class func Password() -> DNRuleSystem{
        let passRuleSystem = DNRuleSystem()
        let _ = passRuleSystem.addRule(DNRule(condition: { (system: DNRuleSystem) -> Bool in
            let input = system.state(Fact.Password) as! String
            let length = Length(length: AppValidationConstants.PasswordMinLength, relation: RelationalOperator.maxOrEqual)
            return length.validate(input.characters.count as AnyObject) == false
            }, assertion: { (system) -> Void in
                system.assert(fact: Fact.Password, grade: 1.0, message: "\(Fact.Password) \(AppValidationError.LengthMessage) \(AppValidationConstants.PasswordMinLength)")
        }))
        let _ = passRuleSystem.addRule(DNRule(condition: { (system: DNRuleSystem) -> Bool in
            let input = system.state(Fact.Password) as! String
            let regX = RegX(pattern: AppValidationConstants.PasswordRegX2)
            return regX.validate(input as AnyObject) == false
            }, assertion: { (system) -> Void in
                system.assert(fact: Fact.Password, grade: 1.0, message: "\(Fact.Password) \(AppValidationError.PasswordInvalidMessage)")
        }))
        let _ = passRuleSystem.addRule(DNRule(condition: { (system: DNRuleSystem) -> Bool in
            //this field is required
            let input = system.state(Fact.Password) as! String
            return (input.characters.count <= 0)
            }, assertion: { (system: DNRuleSystem) -> Void in
                system.assert(fact: Fact.Password, grade: 1.0, message: "\(Fact.Password) \(AppValidationError.RequiredMessage)")
        }))
        return passRuleSystem
    }
    
    class func ConfirmPassword(_ existingRule: inout DNRuleSystem){
        let _ = existingRule.addRule(DNRule(condition: { (system: DNRuleSystem) -> Bool in
            let password = system.state(Fact.Password) as! String
            if let confirm = system.state(Fact.PasswordConfirmation) as? String{
                return (password != confirm)
            }
            return true
            }, assertion: { (system: DNRuleSystem) -> Void in
                system.assert(fact: Fact.PasswordConfirmation, grade: 1.0, message: "\(Fact.PasswordConfirmation) \(AppValidationError.PasswordMissmatchMessage)")
        }))
    }
    
}
