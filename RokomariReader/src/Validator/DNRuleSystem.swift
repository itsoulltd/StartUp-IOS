//
//  DNRuleSystem.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 10/6/15.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation

public enum RuleEvaluationStrategy: Int{
    case ForwardChaining = 0
    case BackwardChaining = 1
    case Progressive = 2
    case OrderedProgressive = 3
}

public class DNRuleSystem: NSObject {
    
    public struct DNRuleSystemKeys{
        static let Progress = "progressKey"
    }
    
    private var stateTable: [String : AnyObject] = [String : AnyObject]()
    private var rules: [DNRuleProtocol] = [DNRuleProtocol]()
    private var strategy: ResolutionStrategyProtocol!
    private var factTable: NSMutableDictionary {
        return strategy.factTable
    }
    
    public init(strategy: RuleEvaluationStrategy = .ForwardChaining){
        super.init()
        setStrategy(strategy)
    }

    public func resetSystem(){
        //TODO: Remove Working Memory
        strategy.reset()
    }
    
    public func evaluateSystem(){
        self.strategy?.execute(self, rules: rules)
    }
    
    private func setStrategy(strategy: RuleEvaluationStrategy){
        if strategy == RuleEvaluationStrategy.BackwardChaining{
            self.strategy = BackwardChaining()
        }
        else if strategy == RuleEvaluationStrategy.Progressive{
            self.strategy = Progressive()
        }
        else if strategy == RuleEvaluationStrategy.OrderedProgressive{
            self.strategy = OrderedProgressive()
        }
        else{
            self.strategy = ForwardChaining()
        }
    }
    
    public func setState(key: String, value: AnyObject){
        stateTable[key] = value
    }
    
    public func state(key: String) -> AnyObject?{
        return stateTable[key]
    }
    
    public func progress() -> Double{
        return gradeFor(fact: DNRuleSystemKeys.Progress) * 100
    }
    
    public func gradeFor(fact fact: String) -> Double{
        if let grade = factTable.objectForKey(fact) as? NSNumber{
            return grade.doubleValue
        }
        return 0.0
    }
    
    public func messagesFor(fact fact: String) -> [String]{
        let messages = strategy.messageBox.objectForKey(fact)
        return (messages != nil) ? messages as! [String] : [String]()
    }
    
    public func satisfied(fact fact: String) -> Bool{
        return gradeFor(fact: fact) == Double(1.0)
    }
    
    public func assert(fact fact: String, grade: NSNumber = NSNumber(double: 1.0), message: String? = nil){
        let vGrade = (grade.doubleValue >= 1.0) ? NSNumber(double: 1.0) : grade
        factTable.setObject(vGrade, forKey: fact)
        strategy.assert(message: message, forFact: fact)
    }
    
    public func retreat(fact fact: String){
        factTable.removeObjectForKey(fact)
    }
    
    public func addRules(from array: [DNRuleProtocol]){
        for rule in array{
            addRule(rule)
        }
    }
    
    public func addRule(rule: DNRuleProtocol) -> DNRuleSystem{
        rule.system = self
        rules.append(rule)
        return self
    }
    
    public func copyRules() -> [DNRuleProtocol]{
        var cRules = [DNRuleProtocol]()
        cRules.appendContentsOf(rules)
        return cRules
    }
    
    public func removeRule(at index: Int) -> DNRuleProtocol{
        let rule = rules.removeAtIndex(index) as DNRuleProtocol
        return rule
    }
    
}
