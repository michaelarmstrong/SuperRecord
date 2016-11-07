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

    //MARK: Entity update
    
    /**
    Update all entity matching the predicate
    
    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    - parameter propertiesToUpdate:
    - parameter predicate: the predicate the entity should match
    - parameter resultType: the default value is UpdatedObjectsCountResultType (rows number)
    - parameter error:
    
    - returns: AnyObject? depends on resultType
    */

    class func updateAll (_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, propertiesToUpdate: [String : AnyObject], predicate:NSPredicate?, resultType: NSBatchUpdateRequestResultType = .updatedObjectsCountResultType) throws -> AnyObject{
        let error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
        let entityName = String(describing: self)
        let request = NSBatchUpdateRequest(entityName: entityName);
        request.propertiesToUpdate = propertiesToUpdate
        request.resultType = resultType
        request.predicate = predicate
        let result =  try! context.execute(request) as! NSBatchUpdateResult;
        if let value = result.result {
            return value as AnyObject
        }
        throw error
    }

    
    //MARK: Entity deletion
    
    /**
    Delete all entity
    
    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    */
    class func deleteAll(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!) -> Void {
        deleteAll(nil, context: context)
    }
    
    /**
    Delete all entity matching the input predicate
    
    - parameter predicate:
    
    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    */
    class func deleteAll(_ predicate: NSPredicate!, context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!) -> Void {
        let results = findAllWithPredicate(predicate, includesPropertyValues: false, context: context, completionHandler: nil)
        for result in results {
            context.delete(result as! NSManagedObject)
        }
    }
    
    //MARK: Entity search
    
    
    /**
    Search for all entity with the specify value or create a new Entity
    
    - parameter predicate:
    
    - parameter includesPropertyValues:

    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    - returns: NSArray of NSManagedObject.
    */
    class func findAllWithPredicate(_ predicate: NSPredicate!, includesPropertyValues: Bool = true, context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, sortDescriptors: [NSSortDescriptor]? = nil, completionHandler handler: ((NSError?) -> Void)! = nil) -> NSArray {
        let entityName = String(describing: self)
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName as String, in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName as String)
        fetchRequest.includesPropertyValues = includesPropertyValues
        fetchRequest.predicate = predicate
        fetchRequest.entity = entityDescription
        fetchRequest.sortDescriptors = sortDescriptors
        var results = NSArray()
        let error : NSError? = nil
        context.performAndWait({ () -> Void in
            results = (try! context.fetch(fetchRequest)) as! [NSManagedObject] as NSArray
        })
        handler?(error);
        return results
    }
    
    
    /**
    Search for all entity with the specify value or create a new Entity

    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    - returns: NSArray of NSManagedObject.
    */
    class func findAll(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, sortDescriptors: [NSSortDescriptor]? = nil) -> NSArray {
        return findAllWithPredicate(nil, context: context, sortDescriptors:sortDescriptors)
    }
    
    
    /**
    Search for all entity with the specify attribute and value
    
    - parameter attribute: name of the attribute of the NSManagedObject

    - parameter value: value of the attribute
    
    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    - returns: NSArray of NSManagedObject.
    */
    class func findAllWithAttribute(_ attribute: String!, value: AnyObject, context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, sortDescriptors: [NSSortDescriptor]? = nil) -> NSArray {
        let predicate = NSPredicate.predicateBuilder(attribute, value: value, predicateOperator: .Equal)
        return findAllWithPredicate(predicate, context: context, sortDescriptors:sortDescriptors)
    }
    
    //MARK: Entity creation

    /**
    Search for the entity with the specify value or create a new Entity
    
    :predicate: attribute predicate
    
    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    - returns: NSManagedObject.
    */
    
    class func findFirstOrCreateWithPredicate(_ predicate: NSPredicate!, context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, handler: ((NSError?) -> Void)! = nil) -> NSManagedObject {
        let entityName = String(describing: self)
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName as String, in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName as String)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        fetchRequest.entity = entityDescription
        var fetchedObjects = NSArray()
        let error : NSError? = nil
        context.performAndWait({ () -> Void in
            let results = (try! context.fetch(fetchRequest)) as NSArray
            fetchedObjects = results
        })
        if let firstObject = fetchedObjects.firstObject as? NSManagedObject {
            handler?(error);
            return firstObject
        }

        let obj = NSManagedObject(entity: entityDescription!, insertInto: context) as NSManagedObject
        
        handler?(error);
        return obj
    }
    
    /**
    Create a new Entity
    
    - parameter context: NSManagedObjectContext
    
    - returns: NSManagedObject.
    */
    class func createNewEntity(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!) -> NSManagedObject {
        let entityName = String(describing: self)
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName as String, in: context)
        let obj = NSManagedObject(entity: entityDescription!, insertInto: context)
        return obj as NSManagedObject
    }

    
    /**
    Search for the entity with the specify value or create a new Entity
    
    - parameter attribute: name of the attribute to find
    
    - parameter value: of the attribute to find

    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    - returns: NSManagedObject.
    */
    class func findFirstOrCreateWithAttribute(_ attribute: String!, value: AnyObject!, context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, handler: ((NSError?) -> Void)! = nil) -> NSManagedObject {
        let predicate = NSPredicate.predicateBuilder(attribute, value: value, predicateOperator: .Equal)
        return findFirstOrCreateWithPredicate(predicate, context: context, handler: handler)
    }


    //MARK: Entity operations
    
    /**
    Count all the entity
    
    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    - parameter error:
    
    - returns: Int of total result set count.
    */
    class func count(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, error: NSErrorPointer) -> Int {
        return count(context, predicate: nil, error: error);
    }
    
    /**
    Count all the entity matching the input predicate
    
    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    - parameter predicate:
    
    - parameter error:
    
    - returns: Int of total result set count.
    */
    class func count(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, predicate : NSPredicate?, error: NSErrorPointer) -> Int {
            let entityName = String(describing: self)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName as String);
            fetchRequest.includesPropertyValues = false
            fetchRequest.includesSubentities = false
            fetchRequest.predicate = predicate
            fetchRequest.propertiesToFetch = [];
            return try! context.count(for: fetchRequest)
    }
    
    
    class func function(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, function: String, fieldName: [String], predicate : NSPredicate?, groupByFieldName: [String], handler: ((NSError!) -> Void)) -> [AnyObject] {
        let error : NSError? = nil
        var expressionsDescription = [AnyObject]();
        for field in fieldName{
            let expression = NSExpression(forKeyPath: field);
            let expressionDescription = NSExpressionDescription();
            expressionDescription.expression = NSExpression(forFunction: function, arguments: [expression])
            expressionDescription.expressionResultType = NSAttributeType.doubleAttributeType;
            expressionDescription.name = field
            expressionsDescription.append(expressionDescription);
        }
        
        let entityName = String(describing: self)

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName as String);
        
        if(groupByFieldName.count > 0 ){
            fetchRequest.propertiesToGroupBy = groupByFieldName
            for groupBy in groupByFieldName {
                expressionsDescription.append(groupBy as AnyObject)
            }

        }
        fetchRequest.propertiesToFetch = expressionsDescription
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        fetchRequest.predicate = predicate

        var results = [AnyObject]()
        
        context.performAndWait({
            do {
                try results = context.fetch(fetchRequest) as [AnyObject]!;
            } catch {

            }
            
        });
        handler(error);
        return results
    }
    
    class func function(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, function: String, fieldName: [String], predicate : NSPredicate?, handler: ((NSError!) -> Void)) -> [Double] {
        let results = self.function(context, function: function , fieldName: fieldName, predicate: predicate, groupByFieldName: [], handler: handler)
        var resultValue = [Double]();

        var tempResult = [Double]()
        for result in results{
            for field in fieldName{
                let value = result.value(forKey: field) as! Double
                tempResult.append(value)
            }
        }
        resultValue = tempResult
        return resultValue;
    }
    
    class func sum(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate? = nil, handler: ((NSError?) -> Void)! = nil) -> [Double] {
        return function(context, function: "sum:", fieldName: fieldName, predicate: predicate, handler: handler);
    }
    
    class func sum(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: String, predicate : NSPredicate? = nil, handler: ((NSError?) -> Void)! = nil) -> Double! {
        var results = sum(context, fieldName: [fieldName], predicate: predicate, handler: handler)
        return results.isEmpty ? 0 : results[0];
    }
    
    class func sum(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate?, groupByField:[String], handler: ((NSError!) -> Void))-> [AnyObject] {
        return function(context, function: "sum:", fieldName: fieldName, predicate: predicate, groupByFieldName: groupByField, handler: handler)
    }
    
    class func max(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate?, handler: ((NSError!) -> Void)) -> [Double] {
        return function(context, function: "max:", fieldName: fieldName, predicate: predicate, handler: handler);
    }
    
    class func max(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: String, predicate : NSPredicate? = nil, handler: ((NSError?) -> Void)! = nil) -> Double! {
        var results = max(context, fieldName: [fieldName], predicate: predicate, handler: handler)
        return results.isEmpty ? 0 : results[0];
    }

    class func max(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate?, groupByField:[String], handler: ((NSError!) -> Void))-> [AnyObject] {
        return function(context, function: "max:", fieldName: fieldName, predicate: predicate, groupByFieldName: groupByField, handler: handler)
    }

    class func min(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate?, handler: ((NSError!) -> Void)) -> [Double] {
        return function(context, function: "min:", fieldName: fieldName, predicate: predicate, handler: handler);
    }
    
    class func min(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: String, predicate : NSPredicate? = nil, handler: ((NSError?) -> Void)! = nil) -> Double! {
        var results = min(context, fieldName: [fieldName], predicate: predicate, handler: handler)
        return results.isEmpty ? 0 : results[0];
    }
    
    class func min(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate?, groupByField:[String], handler: ((NSError!) -> Void))-> [AnyObject] {
        return function(context, function: "min:", fieldName: fieldName, predicate: predicate, groupByFieldName: groupByField, handler: handler)
    }

    class func avg(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate?, handler: ((NSError!) -> Void)) -> [Double] {
        return function(context, function: "average:", fieldName: fieldName, predicate: predicate, handler: handler);
    }
    
    class func avg(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: String, predicate : NSPredicate? = nil, handler: ((NSError?) -> Void)!  = nil) -> Double! {
        var results = avg(context, fieldName: [fieldName], predicate: predicate, handler: handler)
        return results.isEmpty ? 0 : results[0];
    }

    class func avg(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate?, groupByField:[String], handler: ((NSError!) -> Void))-> [AnyObject] {
        return function(context, function: "average:", fieldName: fieldName, predicate: predicate, groupByFieldName: groupByField, handler: handler)
    }


}
