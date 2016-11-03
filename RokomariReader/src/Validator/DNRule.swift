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

public class DNRule: NSObject, DNRuleProtocol{
    
    private weak var _system: DNRuleSystem?
    weak public var system: DNRuleSystem? {
        get{
            return _system
        }
        set{
            _system = newValue
        }
    }
    
    public var assertion: ((system: DNRuleSystem) -> Void)!
    private var blockPredicate: ((system: DNRuleSystem) -> Bool)!
    
    private override init(){
        super.init()
    }
    
    public init(condition: (system: DNRuleSystem) -> Bool, assertion: (system: DNRuleSystem) -> Void) {
        super.init()
        self.blockPredicate = condition
        self.assertion = assertion
    }
    
    public func validate() -> Bool {
        guard let system = _system else{
            print("\(#function) at line \(#line) : DNRuleSystem is nil")
            return false
        }
        return blockPredicate(system: system)
    }
    
    public func executeAssertion() {
        guard let system = _system else{
            print("\(#function) at line \(#line) : DNRuleSystem is nil")
            return
        }
        assertion(system: system)
    }
}

public class DNLogicRule: DNRule{
    
    private var logicTree: Logical!
    private var logicPredicate: ((system: DNRuleSystem) -> AnyObject)!
    
    public init(condition: Logical, value: (system: DNRuleSystem) -> AnyObject, assertion: (system: DNRuleSystem) -> Void) {
        super.init()
        self.logicTree = condition
        self.logicPredicate = value
        self.assertion = assertion
    }
    
    public override func validate() -> Bool {
        guard let system = _system else{
            print("\(#function) at line \(#line) : DNRuleSystem is nil")
            return false
        }
        return logicTree.validate(logicPredicate(system: system))
    }
    
}

public class DNValidationRule: DNRule{
    private var validation: Validation!
    private var logicPredicate: ((system: DNRuleSystem) -> AnyObject)!
    
    public init(validation: Validation, value: (system: DNRuleSystem) -> AnyObject, assertion: (system: DNRuleSystem) -> Void) {
        super.init()
        self.validation = validation
        self.logicPredicate = value
        self.assertion = assertion
    }
    
    public override func validate() -> Bool {
        guard let system = _system else{
            print("\(#function) at line \(#line) : DNRuleSystem is nil")
            return false
        }
        return validation.validate(logicPredicate(system: system))
    }
}
