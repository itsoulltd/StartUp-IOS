//
//  Query.swift
//  RokomariReader
//
//  Created by Towhid Islam on 11/19/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit
import SeliseToolKit

public class Query: DNObject, FormValidator {
    var page: NSNumber = 0
    var size: NSNumber = 20
    var sort: NSArray?
    
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
    
    /*public override func serializeValue(value: AnyObject!, forKey key: String!) -> AnyObject! {
        if key == "engineMapper" {
            return NSNull()
        }else{
            return super.serializeValue(value, forKey: key)
        }
    }*/
}

public class SearchQuery: Query {
    var query: NSString?
    
    func applyFieldValidation() {
        let required = DNRule(condition: { (system: DNRuleSystem) -> Bool in
            let input = system.state("query")
            return (input == nil)
            }, assertion: { (system: DNRuleSystem) -> Void in
                system.assert(fact: "query", grade: 1.0, message: "query is required.")
        })
        addRule(required, forKey: "query")
    }
}
