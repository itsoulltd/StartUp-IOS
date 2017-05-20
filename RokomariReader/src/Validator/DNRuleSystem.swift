//
//  DNRuleSystem.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 10/6/15.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation

public enum RuleEvaluationStrategy: Int{
    case forwardChaining = 0
    case backwardChaining = 1
    case progressive = 2
    case orderedProgressive = 3
}

open class DNRuleSystem: NSObject {
    
    public struct DNRuleSystemKeys{
        static let Progress = "progressKey"
    }
    
    fileprivate var stateTable: [String : AnyObject] = [String : AnyObject]()
    fileprivate var rules: [DNRuleProtocol] = [DNRuleProtocol]()
    fileprivate var strategy: ResolutionStrategyProtocol!
    fileprivate var factTable: NSMutableDictionary {
        return strategy.factTable
    }
    
    public init(strategy: RuleEvaluationStrategy = .forwardChaining){
        super.init()
        setStrategy(strategy)
    }

    open func resetSystem(){
        //TODO: Remove Working Memory
        strategy.reset()
    }
    
    open func evaluateSystem(){
        self.strategy?.execute(self, rules: rules)
    }
    
    fileprivate func setStrategy(_ strategy: RuleEvaluationStrategy){
        if strategy == RuleEvaluationStrategy.backwardChaining{
            self.strategy = BackwardChaining()
        }
        else if strategy == RuleEvaluationStrategy.progressive{
            self.strategy = Progressive()
        }
        else if strategy == RuleEvaluationStrategy.orderedProgressive{
            self.strategy = OrderedProgressive()
        }
        else{
            self.strategy = ForwardChaining()
        }
    }
    
    open func setState(_ key: String, value: AnyObject){
        stateTable[key] = value
    }
    
    open func state(_ key: String) -> AnyObject?{
        return stateTable[key]
    }
    
    open func progress() -> Double{
        return gradeFor(fact: DNRuleSystemKeys.Progress) * 100
    }
    
    open func gradeFor(fact: String) -> Double{
        if let grade = factTable.object(forKey: fact) as? NSNumber{
            return grade.doubleValue
        }
        return 0.0
    }
    
    open func messagesFor(fact: String) -> [String]{
        let messages = strategy.messageBox.object(forKey: fact)
        return (messages != nil) ? messages as! [String] : [String]()
    }
    
    open func satisfied(fact: String) -> Bool{
        return gradeFor(fact: fact) == Double(1.0)
    }
    
    open func assert(fact: String, grade: NSNumber = NSNumber(value: 1.0 as Double), message: String? = nil){
        let vGrade = (grade.doubleValue >= 1.0) ? NSNumber(value: 1.0 as Double) : grade
        factTable.setObject(vGrade, forKey: fact as NSCopying)
        strategy.assert(message: message, forFact: fact)
    }
    
    open func retreat(fact: String){
        factTable.removeObject(forKey: fact)
    }
    
    open func addRules(from array: [DNRuleProtocol]){
        for rule in array{
            let _ = addRule(rule)
        }
    }
    
    open func addRule(_ rule: DNRuleProtocol) -> DNRuleSystem{
        rule.system = self
        rules.append(rule)
        return self
    }
    
    open func copyRules() -> [DNRuleProtocol]{
        var cRules = [DNRuleProtocol]()
        cRules.append(contentsOf: rules)
        return cRules
    }
    
    open func removeRule(at index: Int) -> DNRuleProtocol{
        let rule = rules.remove(at: index) as DNRuleProtocol
        return rule
    }
    
}
