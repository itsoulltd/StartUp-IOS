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
    func assert(message message: String?, forFact fact: String)
    func execute(system: DNRuleSystem, rules: [DNRuleProtocol]) -> Void
    func reset() -> Void
}

public class ForwardChaining: NSObject, ResolutionStrategyProtocol{
    
    private var _factTable: NSMutableDictionary = NSMutableDictionary(capacity: 7)
    private var _factMessageTable: NSMutableDictionary = NSMutableDictionary(capacity: 7)
    
    public var factTable: NSMutableDictionary {
        return _factTable
    }
    
    public var messageBox: NSMutableDictionary{
        return _factMessageTable
    }
    
    public func execute(system: DNRuleSystem, rules: [DNRuleProtocol]) {
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
        system.assert(fact: DNRuleSystem.DNRuleSystemKeys.Progress, grade: fraction)
    }
    
    public func reset() {
        factTable.removeAllObjects()
        messageBox.removeAllObjects()
    }
    
    public func assert(message message: String?, forFact fact: String) {
        if let msg = message{
            var messages = messageBox.objectForKey(fact) as? [String]
            if messages == nil {
                messageBox.setObject([msg], forKey: fact)
            }else{
                messages?.insert(msg, atIndex: 0) //Latest on top.
                messageBox.setObject(messages!, forKey: fact)
            }
        }
    }
    
}

public class BackwardChaining: ForwardChaining{
    
    public override func execute(system: DNRuleSystem, rules: [DNRuleProtocol]) {
        //TODO: implement BackwardChaining
        super.execute(system, rules: rules)
    }
    
}

public class Progressive: ForwardChaining{
    
    private var confirmRules: Set<DNRule> = Set<DNRule>()
    
    func isOrderd() -> Bool{
        return false
    }
    
    public override func execute(system: DNRuleSystem, rules: [DNRuleProtocol]) {
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
        system.assert(fact: DNRuleSystem.DNRuleSystemKeys.Progress, grade: fraction)
    }
    
    public override func reset() {
        super.reset()
        if confirmRules.isEmpty == false{
            confirmRules.removeAll(keepCapacity: true)
        }
    }
    
}

public class OrderedProgressive: Progressive{
    
    override func isOrderd() -> Bool {
        return true
    }
    
}

