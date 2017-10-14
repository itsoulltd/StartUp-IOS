//
//  ValidationInterpreter.swift
//  MymoUpload
//
//  Created by Towhid Islam on 9/19/14.
//  Copyright (c) 2014 Towhid (Selise.ch). All rights reserved.
//

import Foundation

@objc(Validation)
public protocol Validation: NSObjectProtocol{
    func validate(_ value: AnyObject) -> Bool
}

public enum RelationalOperator: Int {
    case equal
    case min
    case minOrEqual
    case max
    case maxOrEqual
}

/*!
* LogicalExpression is abstruct base class, Don't instantiate this Class
*/

@objc(Equal)
open class Equal: NSObject, Validation {
    
    fileprivate let baseValue: AnyObject!
    
    public init(baseValue: AnyObject){
        self.baseValue = baseValue
    }
    
    open func validate(_ value: AnyObject) -> Bool {
        let result = value.hashValue == baseValue.hashValue
        return result
    }
}

@objc(EqualDate)
open class EqualDate: Equal {
    
    override open func validate(_ value: AnyObject) -> Bool {
        if (baseValue is NSDate && value is Date){
            return (value as! Date).compare((baseValue as! Date)) == ComparisonResult.orderedSame
        }
        else{
            return super.validate(value)
        }
    }
}

@objc(Greater)
open class Greater: Equal {
    
    override open func validate(_ value: AnyObject) -> Bool {
        let result = value.hashValue > baseValue.hashValue
        return result
    }
}

@objc(GreaterDate)
open class GreaterDate: Greater {
    
    override open func validate(_ value: AnyObject) -> Bool {
        if (baseValue is NSDate && value is Date){
            return (value as! Date).compare((baseValue as! Date)) == ComparisonResult.orderedDescending
        }
        else{
            return super.validate(value)
        }
    }
}

@objc(Smaller)
open class Smaller: Greater {
    
    override open func validate(_ value: AnyObject) -> Bool {
        let result =  value.hashValue < baseValue.hashValue
        return result
    }
}

@objc(SmallerDate)
open class SmallerDate: Smaller {
    
    override open func validate(_ value: AnyObject) -> Bool {
        if (baseValue is NSDate && value is Date){
            return (value as! Date).compare((baseValue as! Date)) == ComparisonResult.orderedAscending
        }
        else{
            return super.validate(value)
        }
    }
}

@objc(Logical)
open class Logical: NSObject, Validation {
    
    var left: Validation
    var right: Validation
    
    public init(left: Validation, right: Validation){
        self.left = left
        self.right = right
    }
    
    open func validate(_ value: AnyObject) -> Bool {
        //
        fatalError("You have to subclass LogicalExpresion")
    }
}

@objc(And)
open class And: Logical {
    
    override open func validate(_ value: AnyObject) -> Bool {
        let result = left.validate(value) && right.validate(value)
        return result
    }
}
@objc(Or)
open class Or: Logical {
    
    override open func validate(_ value: AnyObject) -> Bool {
        let result = left.validate(value) || right.validate(value)
        return result
    }
}
@objc(Xor)
open class Xor: Logical {
    
    override open func validate(_ value: AnyObject) -> Bool {
        let result = left.validate(value) != right.validate(value)
        return result
    }
}
@objc(Nor)
open class Nor: Logical {
    
    override open func validate(_ value: AnyObject) -> Bool {
        let result = !(left.validate(value) != right.validate(value))
        return result
    }
}
@objc(Length)
open class Length: NSObject, Validation {
    
    fileprivate var validLength: Int
    var targetLength: Int {
        return validLength
    }
    fileprivate var relation: RelationalOperator
    var relationOperator: RelationalOperator{
        return relation
    }
    
    public init(length: Int, relation: RelationalOperator){
        validLength = length
        self.relation = relation
    }
    
    open func validate(_ value: AnyObject) -> Bool {
        
        if value is NSNumber{
            let inValue = value as! Int
            return validationCheck(inValue)
        }
        else{
            return false
        }
    }
    
    fileprivate func validationCheck(_ inValue: Int) -> Bool{
        //
        if (relation ==  RelationalOperator.min && inValue >= validLength){
            return false
        }
        else if (relation ==  RelationalOperator.minOrEqual && inValue > validLength){
            return false
        }
        else if (relation ==  RelationalOperator.max && inValue <= validLength){
            return false
        }
        else if (relation ==  RelationalOperator.maxOrEqual && inValue < validLength){
            return false
        }
        else if (relation ==  RelationalOperator.equal && inValue != validLength){
            return false
        }
        else{
            return true
        }
    }
    
}
@objc(RegX)
open class RegX: NSObject, Validation {
    
    fileprivate var regxString: String
    
    var regx: NSRegularExpression? {
        var regEx: NSRegularExpression?
        do {
            regEx = try NSRegularExpression(pattern: regxString, options: NSRegularExpression.Options.caseInsensitive)
        } catch let error as NSError {
            regEx = nil
            print(error.debugDescription)
        }
        return regEx
    }
    
    public init(pattern: String){
        regxString = pattern
    }
    
    open func validate(_ value: AnyObject) -> Bool {
        
        if value is NSString{
            let input = value as! String
            guard let regx = self.regx else{
                return false
            }
            let matches = regx.numberOfMatches(in: input, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, input.characters.count))
            return matches == 1
        }
        else{
            return false
        }
    }
}
