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

:param: left
:param: right

:returns: NSPredicate
*/
public func & (left : NSPredicate, right : NSPredicate )-> NSPredicate{
    return [left] & [right]
}

/**
Create a new NSPredicate as logical AND of left and right predicates

:param: left
:param: right a collection NSPredicate

:returns: NSPredicate
*/
public func & (left : NSPredicate, right : [NSPredicate] )-> NSPredicate{
    return [left] & right
}

/**
Create a new NSPredicate as logical AND of left and right predicates

:param: left a collection NSPredicate
:param: right a collection NSPredicate

:returns: NSPredicate
*/
public func & (left : [NSPredicate], right : [NSPredicate] )-> NSPredicate{
    return NSCompoundPredicate.andPredicateWithSubpredicates(left + right)
}

/**

Create a new NSPredicate as logical OR of left and right predicate

:param: left
:param: right

:returns: NSPredicate
*/

public func | (left : NSPredicate, right : NSPredicate )-> NSPredicate{
    return [left] | [right]
}

/**

Create a new NSPredicate as logical OR of left and right predicates

:param: left
:param: right a collection NSPredicate

:returns: NSPredicate
*/

public func | (left : NSPredicate, right : [NSPredicate] )-> NSPredicate{
    return [left] | right
}


/**

Create a new NSPredicate as logical OR of left and right predicates

:param: left a collection NSPredicate
:param: right a collection NSPredicate

:returns: NSPredicate
*/
public func | (left : [NSPredicate], right : [NSPredicate] )-> NSPredicate{
    return NSCompoundPredicate.orPredicateWithSubpredicates(left + right)
}

public enum NSLogicOperator : String {
    case And = "AND"
    case Or = "OR"
}

public enum NSPredicateOperator : String {
    case And = "AND"
    case Or = "OR"
    case In = "IN"
    case Equal = "=="
    case NotEqual = "!="
    case GreaterThan = ">"
    case GreaterThanOrEqual = ">="
    case LessThan = "<"
    case LessThanOrEqual = "<="
}

public extension NSPredicate {
    
public convenience init?(firstPredicate : NSPredicate, secondPredicate: NSPredicate, predicateOperator: NSLogicOperator ) {
            self.init(format: "(\(firstPredicate)) \(predicateOperator.rawValue) (\(secondPredicate))")
    }

    
public class func predicateBuilder(attribute: String!, value: AnyObject, predicateOperator: NSPredicateOperator ) -> NSPredicate? {
        var predicate = NSPredicate(format: "%K \(predicateOperator.rawValue) $value", attribute)
        predicate = predicate?.predicateWithSubstitutionVariables(["value" : value]);
        return predicate
    }
}