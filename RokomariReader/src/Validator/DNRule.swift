//
//  DNRule.swift
//  StartupProjectSampleA
//
//  Created by Towhid on 10/6/15.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation

public protocol DNRuleProtocol: NSObjectProtocol {
    weak var system: DNRuleSystem? {get set}
    func validate() -> Bool
    func executeAssertion() -> Void
}

open class DNRule: NSObject, DNRuleProtocol{
    
    fileprivate weak var _system: DNRuleSystem?
    weak open var system: DNRuleSystem? {
        get{
            return _system
        }
        set{
            _system = newValue
        }
    }
    
    open var assertion: ((_ system: DNRuleSystem) -> Void)!
    fileprivate var blockPredicate: ((_ system: DNRuleSystem) -> Bool)!
    
    fileprivate override init(){
        super.init()
    }
    
    public init(condition: @escaping (_ system: DNRuleSystem) -> Bool, assertion: @escaping (_ system: DNRuleSystem) -> Void) {
        super.init()
        self.blockPredicate = condition
        self.assertion = assertion
    }
    
    open func validate() -> Bool {
        guard let system = _system else{
            print("\(#function) at line \(#line) : DNRuleSystem is nil")
            return false
        }
        return blockPredicate(system)
    }
    
    open func executeAssertion() {
        guard let system = _system else{
            print("\(#function) at line \(#line) : DNRuleSystem is nil")
            return
        }
        assertion(system)
    }
}

open class DNLogicRule: DNRule{
    
    fileprivate var logicTree: Logical!
    fileprivate var logicPredicate: ((_ system: DNRuleSystem) -> AnyObject)!
    
    public init(condition: Logical, value: @escaping (_ system: DNRuleSystem) -> AnyObject, assertion: @escaping (_ system: DNRuleSystem) -> Void) {
        super.init()
        self.logicTree = condition
        self.logicPredicate = value
        self.assertion = assertion
    }
    
    open override func validate() -> Bool {
        guard let system = _system else{
            print("\(#function) at line \(#line) : DNRuleSystem is nil")
            return false
        }
        return logicTree.validate(logicPredicate(system))
    }
    
}

open class DNValidationRule: DNRule{
    fileprivate var validation: Validation!
    fileprivate var logicPredicate: ((_ system: DNRuleSystem) -> AnyObject)!
    
    public init(validation: Validation, value: @escaping (_ system: DNRuleSystem) -> AnyObject, assertion: @escaping (_ system: DNRuleSystem) -> Void) {
        super.init()
        self.validation = validation
        self.logicPredicate = value
        self.assertion = assertion
    }
    
    open override func validate() -> Bool {
        guard let system = _system else{
            print("\(#function) at line \(#line) : DNRuleSystem is nil")
            return false
        }
        return validation.validate(logicPredicate(system))
    }
}
