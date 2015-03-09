//
//  NSManagedObjectExtension.swift
//
//  SuperRecord - A small set of utilities to make working with CoreData a bit easier.
//  http://mike.kz/
//
//  Created by Michael Armstrong on 12/10/2014.
//  Copyright (c) 2014 SuperArmstrong.UK. All rights reserved.
//
//  RESPONSIBILITY : Several helpers for NSManagedObject to make common operations simpler.

import CoreData

public extension NSManagedObject {

    //MARK: Entity deletion
    
    /**
    Delete all entity
    
    :param: context the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    */
    class func deleteAll(context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!) -> Void {
        deleteAll(nil, context: context)
    }
    
    /**
    Delete all entity matching the input predicate
    
    :param: predicate
    
    :param: context the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    */
    class func deleteAll(predicate: NSPredicate!, context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!) -> Void {
        let results = findAllWithPredicate(predicate, context: context, completionHandler: nil)
        for result in results {
            context.deleteObject(result as! NSManagedObject)
        }
    }
    
    //MARK: Entity search

    
    /**
    Search for all entity with the specify value or create a new Entity
    
    :param: predicate
    
    :param: context the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    :returns: NSArray of NSManagedObject.
    */
    class func findAllWithPredicate(predicate: NSPredicate!, context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, completionHandler handler: ((NSError!) -> Void)! = nil) -> NSArray {
        
        var entityName : NSString = NSStringFromClass(self)
        let entityDescription = NSEntityDescription.entityForName(entityName as String, inManagedObjectContext: context)
        let fetchRequest = NSFetchRequest(entityName: entityName as String)
        fetchRequest.predicate = predicate
        fetchRequest.entity = entityDescription
        var results = NSArray()
        var error : NSError?
        context.performBlockAndWait({ () -> Void in
            results = context.executeFetchRequest(fetchRequest, error: &error)! as! [NSManagedObject]
        })
        handler?(error);
        return results
    }

    
    /**
    Search for all entity with the specify value or create a new Entity

    :param: context the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    :returns: NSArray of NSManagedObject.
    */
    class func findAll(context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!) -> NSArray {
        return findAllWithPredicate(nil, context: context)
    }
    
    
    /**
    Search for all entity with the specify attribute and value
    
    :param: attribute name of the attribute of the NSManagedObject

    :param: value value of the attribute
    
    :param: context the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    :returns: NSArray of NSManagedObject.
    */
    class func findAllWithAttribute(attribute: String!, value: String!, context: NSManagedObjectContext) -> NSArray {
        let predicate = NSPredicate(format: "%K = %@", attribute, value)
        return findAllWithPredicate(predicate, context: context)
    }
    
    //MARK: Entity creation

    /**
    Search for the entity with the specify value or create a new Entity
    
    :predicate: attribute predicate
    
    :param: context the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    :returns: NSManagedObject.
    */
    
    class func findFirstOrCreateWithPredicate(predicate: NSPredicate!, context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, handler: ((NSError!) -> Void)! = nil) -> NSManagedObject {
        var entityName : NSString = NSStringFromClass(self)
        let entityDescription = NSEntityDescription.entityForName(entityName as String, inManagedObjectContext: context)
        let fetchRequest = NSFetchRequest(entityName: entityName as String)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        fetchRequest.entity = entityDescription
        var fetchedObjects = NSArray()
        var error : NSError?
        context.performBlockAndWait({ () -> Void in
            let results = context.executeFetchRequest(fetchRequest, error: &error)! as NSArray
            fetchedObjects = results
        })
        if let firstObject = fetchedObjects.firstObject as? NSManagedObject {
            handler?(error);
            return firstObject
        }

        var obj = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: context) as NSManagedObject
        
        handler?(error);
        return obj
    }
    
    /**
    Create a new Entity
    
    :param: context NSManagedObjectContext
    
    :returns: NSManagedObject.
    */
    class func createNewEntity(context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!) -> NSManagedObject {
        var entityName : NSString = NSStringFromClass(self)
        let entityDescription = NSEntityDescription.entityForName(entityName as String, inManagedObjectContext: context)
        var obj = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: context)
        return obj as NSManagedObject
    }

    
    /**
    Search for the entity with the specify value or create a new Entity
    
    :param: attribute name of the attribute to find

    :param: value of the attribute to find

    :param: context the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    :returns: NSManagedObject.
    */
    class func findFirstOrCreateWithAttribute(attribute: String!, value: AnyObject!, context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, handler: ((NSError!) -> Void)! = nil) -> NSManagedObject {
        var predicate = NSPredicate.predicateBuilder(attribute, value: value, predicateOperator: .Equal)
        return findFirstOrCreateWithPredicate(predicate, context: context, handler: handler)
    }


    //MARK: Entity operations
    
    /**
    Count all the entity
    
    :param: context the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    :param: error
    
    :returns: Int of total result set count.
    */
    class func count(context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, error: NSErrorPointer) -> Int {
        return count(context: context, predicate: nil, error: error);
    }
    
    /**
    Count all the entity matching the input predicate
    
    :param: context the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    :param: predicate
    
    :param: error
    
    :returns: Int of total result set count.
    */
    class func count(context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, predicate : NSPredicate?, error: NSErrorPointer) -> Int {
            var entityName : NSString = NSStringFromClass(self)
            var fetchRequest = NSFetchRequest(entityName: entityName as String);
            fetchRequest.includesPropertyValues = false
            fetchRequest.includesSubentities = false
            fetchRequest.predicate = predicate
            fetchRequest.propertiesToFetch = [];
            return context.countForFetchRequest(fetchRequest, error: error)
    }
    
    class func function(context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, function: String, fieldName: [String], predicate : NSPredicate?, handler: ((NSError!) -> Void)) -> [Double] {
        
        var expressionsDescription = [NSExpressionDescription]();
        var error : NSError?
        for field in fieldName{
            var expression = NSExpression(forKeyPath: field);
            var expressionDescription = NSExpressionDescription();
            expressionDescription.expression = NSExpression(forFunction: function, arguments: [expression])
            expressionDescription.expressionResultType = NSAttributeType.DoubleAttributeType;
            expressionDescription.name = field
            expressionsDescription.append(expressionDescription);
        }
        
        var entityName : NSString = NSStringFromClass(self)
        var fetchRequest = NSFetchRequest(entityName: entityName as String);
        fetchRequest.propertiesToFetch = expressionsDescription
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        fetchRequest.predicate = predicate
        var results = [AnyObject]();
        var resultValue = [Double]();
        context.performBlockAndWait({ () -> Void in
            results = context.executeFetchRequest(fetchRequest, error: &error)! as! [NSDictionary];
            var tempResult = [Double]()
            for result in results{
                for field in fieldName{
                    var value = result.valueForKey(field) as! Double
                    tempResult.append(value)
                }
            }
            resultValue = tempResult
            handler(error);
        })
        return resultValue;
    }
    
    class func sum(context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate?, handler: ((NSError!) -> Void)) -> [Double] {
        return function(context: context, function: "sum:", fieldName: fieldName, predicate: predicate, handler: handler);
    }
    
    class func sum(context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: String, predicate : NSPredicate?, handler: ((NSError!) -> Void)) -> Double! {
        var results = sum(context: context, fieldName: [fieldName], predicate: predicate, handler: handler)
        return results.isEmpty ? 0 : results[0];
    }
    
    class func max(context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate?, handler: ((NSError!) -> Void)) -> [Double] {
        return function(context: context, function: "max:", fieldName: fieldName, predicate: predicate, handler: handler);
    }
    
    class func max(context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: String, predicate : NSPredicate?, handler: ((NSError!) -> Void)) -> Double! {
        var results = max(context: context, fieldName: [fieldName], predicate: predicate, handler: handler)
        return results.isEmpty ? 0 : results[0];
    }
    
    class func min(context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate?, handler: ((NSError!) -> Void)) -> [Double] {
        return function(context: context, function: "min:", fieldName: fieldName, predicate: predicate, handler: handler);
    }
    
    class func min(context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: String, predicate : NSPredicate?, handler: ((NSError!) -> Void)) -> Double! {
        var results = min(context: context, fieldName: [fieldName], predicate: predicate, handler: handler)
        return results.isEmpty ? 0 : results[0];
    }
    
    class func avg(context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate?, handler: ((NSError!) -> Void)) -> [Double] {
        return function(context: context, function: "average:", fieldName: fieldName, predicate: predicate, handler: handler);
    }
    
    class func avg(context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: String, predicate : NSPredicate?, handler: ((NSError!) -> Void)) -> Double! {
        var results = avg(context: context, fieldName: [fieldName], predicate: predicate, handler: handler)
        return results.isEmpty ? 0 : results[0];
    }
}