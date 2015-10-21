//
//  NSPredicateExtension.swift
//  SuperRecord
//
//  Created by Piergiuseppe Longo on 26/11/14.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import Foundation

//MARK: Logical operators
/**
Create a new NSPredicate as logical AND of left and right predicate

- parameter left:
- parameter right:

- returns: NSPredicate
*/
public func & (left : NSPredicate, right : NSPredicate )-> NSPredicate{
    return [left] & [right]
}

/**
Create a new NSPredicate as logical AND of left and right predicates

- parameter left:
- parameter right: a collection NSPredicate

- returns: NSPredicate
*/
public func & (left : NSPredicate, right : [NSPredicate] )-> NSPredicate{
    return [left] & right
}

/**
Create a new NSPredicate as logical AND of left and right predicates

- parameter left: a collection NSPredicate
- parameter right: a collection NSPredicate

- returns: NSPredicate
*/
public func & (left : [NSPredicate], right : [NSPredicate] )-> NSPredicate{
    return NSCompoundPredicate(andPredicateWithSubpredicates: left + right)
}

/**

Create a new NSPredicate as logical OR of left and right predicate

- parameter left:
- parameter right:

- returns: NSPredicate
*/

public func | (left : NSPredicate, right : NSPredicate )-> NSPredicate{
    return [left] | [right]
}

/**

Create a new NSPredicate as logical OR of left and right predicates

- parameter left:
- parameter right: a collection NSPredicate

- returns: NSPredicate
*/

public func | (left : NSPredicate, right : [NSPredicate] )-> NSPredicate{
    return [left] | right
}


/**

Create a new NSPredicate as logical OR of left and right predicates

- parameter left: a collection NSPredicate
- parameter right: a collection NSPredicate

- returns: NSPredicate
*/
public func | (left : [NSPredicate], right : [NSPredicate] )-> NSPredicate{
    return NSCompoundPredicate(orPredicateWithSubpredicates: left + right)
}

/**
Used to specify the the logical operator to use in the init of a complex NSPredicate
*/
public enum NSLogicOperator : String {
    /**
    And Operator
    */
    case And = "AND"
    
    /**
    OR Operator
    */
    case Or = "OR"
}

/**
Used to specify the the  operator to use in NSPredicate.predicateBuilder
*/
public enum NSPredicateOperator : String {
    /**
    Operator &&
    */
    case And = "AND"
    
    /**
    Operator ||
    */
    case Or = "OR"
    
    /**
    Operator IN
    */
    case In = "IN"
    
    /**
    Operator ==
    */
    case Equal = "=="
    
    /**
    Operator !=
    */
    case NotEqual = "!="
    
    /**
    Operator >
    */
    case GreaterThan = ">"
    
    /**
    Operator >=
    */
    case GreaterThanOrEqual = ">="
    
    /**
    Operator <
    */
    case LessThan = "<"
    
    /**
    Operator <=
    */
    case LessThanOrEqual = "<="
}

public extension NSPredicate {
    
    /**
    Init a new NSPredicate using the input predicates adding parenthesis for more complex NSPredicate
    
    - parameter firstPredicate:
    - parameter secondPredicate: 
    - parameter NSLogicOperator: to use in the predicate AND/OR
    
    - returns: NSPredicate
    */
    public convenience init?(firstPredicate : NSPredicate, secondPredicate: NSPredicate, predicateOperator: NSLogicOperator ) {
            self.init(format: "(\(firstPredicate)) \(predicateOperator.rawValue) (\(secondPredicate))")
    }

    /**
    
    Build NSPredicate using the input parameters

    - parameter attribute: the name of the attribute
    - parameter value: the value the attribute should assume
    - parameter predicateOperator: to use in the predicate
    
    - returns: NSPredicate
    */
    public class func predicateBuilder(attribute: String!, value: AnyObject, predicateOperator: NSPredicateOperator) -> NSPredicate? {
        var predicate = NSPredicate(format: "%K \(predicateOperator.rawValue) $value", attribute)
        predicate = predicate.predicateWithSubstitutionVariables(["value" : value]);
        return predicate
    }
}