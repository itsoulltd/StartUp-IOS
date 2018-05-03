//
//  Validation.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/2/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import CoreDataStack
import NGAppKit

protocol FormValidator {
    func addRule(_ rule: NGRule, forKey key: String) -> Void
    func validate(_ key: String, forValue value: AnyObject?) -> (invalid:Bool, reasons:[String])
}

open class BaseForm: NGObject, FormValidator{
    
    fileprivate var engineMapper: [String:NGRuleSystem] = [String:NGRuleSystem]()
    func addRule(_ rule: NGRule, forKey key: String) -> Void{
        var engine = engineMapper[key]
        if engine == nil {
            engine = NGRuleSystem(strategy: RuleEvaluationStrategy.forwardChaining)
        }
        let _ = engine?.addRule(rule)
        engineMapper[key] = engine
    }
    
    func validate(_ key: String, forValue value: AnyObject?) -> (invalid:Bool, reasons:[String]) {
        if let engin = engineMapper[key] {
            if let val = value{
                engin.setState(key, value: val)
            }else{
                if let val = self.value(forKeyPath: key){
                    engin.setState(key, value: val as AnyObject)
                }
            }
            engin.resetSystem()
            engin.evaluateSystem()
            let expression = engin.satisfied(key)
            return (expression, engin.messagesFor(key))
        }
        return (false, ["No Validator is found for \(key)!?! Please Check"])
    }
    
    func addRequiredRule(to field: String) {
        let required = NGRule(condition: { (system: NGRuleSystem) -> Bool in
            let input = system.state(field)
            return (input == nil)
            }, assertion: { (system: NGRuleSystem) -> Void in
                system.assert(field, grade: 1.0, message: "\(field) is required.")
        })
        addRule(required, forKey: field)
    }
    
}
