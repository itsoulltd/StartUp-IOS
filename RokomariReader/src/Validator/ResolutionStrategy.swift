//
//  ResolutionStrategy.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 10/7/15.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation

public protocol ResolutionStrategyProtocol : NSObjectProtocol{
    var factTable: NSMutableDictionary {get} //Is our Working Memory
    var messageBox: NSMutableDictionary {get} //Simple Log keeping.
    func assert(message: String?, forFact fact: String)
    func execute(_ system: DNRuleSystem, rules: [DNRuleProtocol]) -> Void
    func reset() -> Void
}

open class ForwardChaining: NSObject, ResolutionStrategyProtocol{
    
    fileprivate var _factTable: NSMutableDictionary = NSMutableDictionary(capacity: 7)
    fileprivate var _factMessageTable: NSMutableDictionary = NSMutableDictionary(capacity: 7)
    
    open var factTable: NSMutableDictionary {
        return _factTable
    }
    
    open var messageBox: NSMutableDictionary{
        return _factMessageTable
    }
    
    open func execute(_ system: DNRuleSystem, rules: [DNRuleProtocol]) {
        //evaluate
        let total = rules.count
        var confirmCount = 0
        for rule in rules{
            if rule.validate() == true{
                confirmCount += 1
                rule.executeAssertion()
            }
        }
        let fraction = Double(confirmCount) / Double(total)
        system.assert(fact: DNRuleSystem.DNRuleSystemKeys.Progress, grade: NSNumber(value: fraction))
    }
    
    open func reset() {
        factTable.removeAllObjects()
        messageBox.removeAllObjects()
    }
    
    open func assert(message: String?, forFact fact: String) {
        if let msg = message{
            var messages = messageBox.object(forKey: fact) as? [String]
            if messages == nil {
                messageBox.setObject([msg], forKey: fact as NSCopying)
            }else{
                messages?.insert(msg, at: 0) //Latest on top.
                messageBox.setObject(messages!, forKey: fact as NSCopying)
            }
        }
    }
    
}

open class BackwardChaining: ForwardChaining{
    
    open override func execute(_ system: DNRuleSystem, rules: [DNRuleProtocol]) {
        //TODO: implement BackwardChaining
        super.execute(system, rules: rules)
    }
    
}

open class Progressive: ForwardChaining{
    
    fileprivate var confirmRules: Set<DNRule> = Set<DNRule>()
    
    func isOrderd() -> Bool{
        return false
    }
    
    open override func execute(_ system: DNRuleSystem, rules: [DNRuleProtocol]) {
        //evaluate
        for rule in rules{
            if confirmRules.contains(rule as! DNRule) == false{
                let result = rule.validate()
                if (isOrderd() == true && result == false){
                    break
                }
                if result == true{
                    confirmRules.insert(rule as! DNRule)
                    rule.executeAssertion()
                }
            }
        }//
        let total = rules.count
        let confirmCount = confirmRules.count
        let fraction = Double(confirmCount) / Double(total)
        system.assert(fact: DNRuleSystem.DNRuleSystemKeys.Progress, grade: NSNumber(value: fraction))
    }
    
    open override func reset() {
        super.reset()
        if confirmRules.isEmpty == false{
            confirmRules.removeAll(keepingCapacity: true)
        }
    }
    
}

open class OrderedProgressive: Progressive{
    
    override func isOrderd() -> Bool {
        return true
    }
    
}

