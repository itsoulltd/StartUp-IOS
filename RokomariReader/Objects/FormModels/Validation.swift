//
//  Validation.swift
//  RokomariReader
//
//  Created by Towhid Islam on 12/2/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import SeliseToolKit

protocol FormValidator {
    func addRule(rule: DNRule, forKey key: String) -> Void
    func validate(key: String, forValue value: AnyObject?) -> (invalid:Bool, reasons:[String])
}

public class BaseForm: DNObject, FormValidator{
    
    private var engineMapper: [String:DNRuleSystem] = [String:DNRuleSystem]()
    func addRule(rule: DNRule, forKey key: String) -> Void{
        var engine = engineMapper[key]
        if engine == nil {
            engine = DNRuleSystem(strategy: RuleEvaluationStrategy.ForwardChaining)
        }
        engine?.addRule(rule)
        engineMapper[key] = engine
    }
    
    func validate(key: String, forValue value: AnyObject?) -> (invalid:Bool, reasons:[String]) {
        if let engin = engineMapper[key] {
            if let val = value{
                engin.setState(key, value: val)
            }else{
                if let val = valueForKeyPath(key){
                    engin.setState(key, value: val)
                }
            }
            engin.resetSystem()
            engin.evaluateSystem()
            let expression = engin.satisfied(fact: key)
            return (expression, engin.messagesFor(fact: key))
        }
        return (false, ["No Validator is found for \(key)!?! Please Check"])
    }
    
    func addRequiredRule(to field: String) {
        let required = DNRule(condition: { (system: DNRuleSystem) -> Bool in
            let input = system.state(field)
            return (input == nil)
            }, assertion: { (system: DNRuleSystem) -> Void in
                system.assert(fact: field, grade: 1.0, message: "\(field) is required.")
        })
        addRule(required, forKey: field)
    }
    
}
