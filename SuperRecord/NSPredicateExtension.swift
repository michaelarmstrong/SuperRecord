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
func & (left : NSPredicate, right : NSPredicate )-> NSPredicate{
    return [left] & [right]
}

/**
Create a new NSPredicate as logical AND of left and right predicates

:param: left
:param: right a collection NSPredicate

:returns: NSPredicate
*/
func & (left : NSPredicate, right : [NSPredicate] )-> NSPredicate{
    return [left] & right
}

/**
Create a new NSPredicate as logical AND of left and right predicates

:param: left a collection NSPredicate
:param: right a collection NSPredicate

:returns: NSPredicate
*/
func & (left : [NSPredicate], right : [NSPredicate] )-> NSPredicate{
    return NSCompoundPredicate.andPredicateWithSubpredicates(left + right)
}

/**

Create a new NSPredicate as logical OR of left and right predicate

:param: left
:param: right

:returns: NSPredicate
*/

func | (left : NSPredicate, right : NSPredicate )-> NSPredicate{
    return [left] | [right]
}

/**

Create a new NSPredicate as logical OR of left and right predicates

:param: left
:param: right a collection NSPredicate

:returns: NSPredicate
*/

func | (left : NSPredicate, right : [NSPredicate] )-> NSPredicate{
    return [left] | right
}


/**

Create a new NSPredicate as logical OR of left and right predicates

:param: left a collection NSPredicate
:param: right a collection NSPredicate

:returns: NSPredicate
*/
func | (left : [NSPredicate], right : [NSPredicate] )-> NSPredicate{
    return NSCompoundPredicate.orPredicateWithSubpredicates(left + right)
}

extension NSPredicate {    

}