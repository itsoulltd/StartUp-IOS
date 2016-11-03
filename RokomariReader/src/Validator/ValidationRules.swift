//
//  ValidationInterpreter.swift
//  MymoUpload
//
//  Created by Towhid Islam on 9/19/14.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation

public protocol Validation: NSObjectProtocol{
    func validate(value: AnyObject) -> Bool
}

public enum RelationalOperator: Int {
    
    case Equal
    case Min
    case MinOrEqual
    case Max
    case MaxOrEqual
}

/*!
* LogicalExpression is abstruct base class, Don't instantiate this Class
*/

public class Equal: NSObject, Validation {
    
    private let baseValue: AnyObject!
    
    public init(baseValue: AnyObject){
        self.baseValue = baseValue
    }
    
    public func validate(value: AnyObject) -> Bool {
        let result = value.hashValue == baseValue.hashValue
        return result
    }
}

public class EqualDate: Equal {
    
    override public func validate(value: AnyObject) -> Bool {
        if (baseValue is NSDate && value is NSDate){
            return (value as! NSDate).compare((baseValue as! NSDate)) == NSComparisonResult.OrderedSame
        }
        else{
            return super.validate(value)
        }
    }
}

public class Greater: Equal {
    
    override public func validate(value: AnyObject) -> Bool {
        let result = value.hashValue > baseValue.hashValue
        return result
    }
}

public class GreaterDate: Greater {
    
    override public func validate(value: AnyObject) -> Bool {
        if (baseValue is NSDate && value is NSDate){
            return (value as! NSDate).compare((baseValue as! NSDate)) == NSComparisonResult.OrderedDescending
        }
        else{
            return super.validate(value)
        }
    }
}

public class Smaller: Greater {
    
    override public func validate(value: AnyObject) -> Bool {
        let result =  value.hashValue < baseValue.hashValue
        return result
    }
}

public class SmallerDate: Smaller {
    
    override public func validate(value: AnyObject) -> Bool {
        if (baseValue is NSDate && value is NSDate){
            return (value as! NSDate).compare((baseValue as! NSDate)) == NSComparisonResult.OrderedAscending
        }
        else{
            return super.validate(value)
        }
    }
}

public class Logical: NSObject, Validation {
    
    var left: Validation
    var right: Validation
    
    public init(left: Validation, right: Validation){
        self.left = left
        self.right = right
    }
    
    public func validate(value: AnyObject) -> Bool {
        //
        fatalError("You have to subclass LogicalExpresion")
    }
}

public class And: Logical {
    
    override public func validate(value: AnyObject) -> Bool {
        let result = left.validate(value) && right.validate(value)
        return result
    }
}

public class Or: Logical {
    
    override public func validate(value: AnyObject) -> Bool {
        let result = left.validate(value) || right.validate(value)
        return result
    }
}

public class Xor: Logical {
    
    override public func validate(value: AnyObject) -> Bool {
        let result = left.validate(value) != right.validate(value)
        return result
    }
}

public class Nor: Logical {
    
    override public func validate(value: AnyObject) -> Bool {
        let result = !(left.validate(value) != right.validate(value))
        return result
    }
}

public class Length: NSObject, Validation {
    
    private var validLength: Int
    var targetLength: Int {
        return validLength
    }
    private var relation: RelationalOperator
    var relationOperator: RelationalOperator{
        return relation
    }
    
    public init(length: Int, relation: RelationalOperator){
        validLength = length
        self.relation = relation
    }
    
    public func validate(value: AnyObject) -> Bool {
        
        if value is NSNumber{
            let inValue = value as! Int
            return validationCheck(inValue)
        }
        else{
            return false
        }
    }
    
    private func validationCheck(inValue: Int) -> Bool{
        //
        if (relation ==  RelationalOperator.Min && inValue >= validLength){
            return false
        }
        else if (relation ==  RelationalOperator.MinOrEqual && inValue > validLength){
            return false
        }
        else if (relation ==  RelationalOperator.Max && inValue <= validLength){
            return false
        }
        else if (relation ==  RelationalOperator.MaxOrEqual && inValue < validLength){
            return false
        }
        else if (relation ==  RelationalOperator.Equal && inValue != validLength){
            return false
        }
        else{
            return true
        }
    }
    
}

public class RegX: NSObject, Validation {
    
    private var regxString: String
    
    var regx: NSRegularExpression? {
        var regEx: NSRegularExpression?
        do {
            regEx = try NSRegularExpression(pattern: regxString, options: NSRegularExpressionOptions.CaseInsensitive)
        } catch let error as NSError {
            regEx = nil
            print(error.debugDescription)
        }
        return regEx
    }
    
    public init(pattern: String){
        regxString = pattern
    }
    
    public func validate(value: AnyObject) -> Bool {
        
        if value is NSString{
            let input = value as! String
            guard let regx = self.regx else{
                return false
            }
            let matches = regx.numberOfMatchesInString(input, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, input.characters.count))
            return matches == 1
        }
        else{
            return false
        }
    }
}
