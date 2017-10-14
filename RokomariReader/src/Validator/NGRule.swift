//
//  NGRule.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 10/6/15.
//  Copyright © 2015 Towhid (Selise.ch). All rights reserved.
//

import Foundation

@objc(NGRuleProtocol)
public protocol NGRuleProtocol: NSObjectProtocol {
    weak var system: NGRuleSystem? {get set}
    func validate() -> Bool
    func executeAssertion() -> Void
}

@objc(NGRule)
open class NGRule: NSObject, NGRuleProtocol{
    
    fileprivate weak var _system: NGRuleSystem?
    weak open var system: NGRuleSystem? {
        get{
            return _system
        }
        set{
            _system = newValue
        }
    }
    
    open var assertion: ((_ system: NGRuleSystem) -> Void)!
    fileprivate var blockPredicate: ((_ system: NGRuleSystem) -> Bool)!
    
    fileprivate override init(){
        super.init()
    }
    
    public init(condition: @escaping (_ ruleSystem : NGRuleSystem) -> Bool, assertion: @escaping (_ ruleSystem : NGRuleSystem) -> Void) {
        super.init()
        self.blockPredicate = condition
        self.assertion = assertion
    }
    
    open func validate() -> Bool {
        guard let system = _system else{
            print("\(#function) at line \(#line) : NGRuleSystem is nil")
            return false
        }
        return blockPredicate(system)
    }
    
    open func executeAssertion() {
        guard let system = _system else{
            print("\(#function) at line \(#line) : NGRuleSystem is nil")
            return
        }
        assertion(system)
    }
}

@objc(NGLogicRule)
open class NGLogicRule: NGRule{
    
    fileprivate var logicTree: Logical!
    fileprivate var logicPredicate: ((_ ruleSystem: NGRuleSystem) -> AnyObject)!
    
    public init(condition: Logical, value: @escaping (_ ruleSystem: NGRuleSystem) -> AnyObject, assertion: @escaping (_ ruleSystem: NGRuleSystem) -> Void) {
        super.init()
        self.logicTree = condition
        self.logicPredicate = value
        self.assertion = assertion
    }
    
    open override func validate() -> Bool {
        guard let system = _system else{
            print("\(#function) at line \(#line) : NGRuleSystem is nil")
            return false
        }
        return logicTree.validate(logicPredicate(system))
    }
    
}

@objc(NGValidationRule)
open class NGValidationRule: NGRule{
    fileprivate var validation: Validation!
    fileprivate var logicPredicate: ((_ ruleSystem: NGRuleSystem) -> AnyObject)!
    
    public init(validation: Validation, value: @escaping (_ ruleSystem: NGRuleSystem) -> AnyObject, assertion: @escaping (_ ruleSystem: NGRuleSystem) -> Void) {
        super.init()
        self.validation = validation
        self.logicPredicate = value
        self.assertion = assertion
    }
    
    open override func validate() -> Bool {
        guard let system = _system else{
            print("\(#function) at line \(#line) : NGRuleSystem is nil")
            return false
        }
        return validation.validate(logicPredicate(system))
    }
}
