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
        let results = findAll(context: context)
        for result in results {
            context.deleteObject(result as NSManagedObject)
        }
    }
    
    
    /**
    Delete all entity matching the input predicate
    
    :param: predicate
    
    :param: context the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
    
    */
    class func deleteAll(predicate: NSPredicate!, context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!) -> Void {
        let results = findAllWithPredicate(predicate, context: context, completionHandler: nil)
        for result in results {
            context.deleteObject(result as NSManagedObject)
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
        let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.entity = entityDescription
        var results = NSArray()
        var error : NSError?
        context.performBlockAndWait({ () -> Void in
            results = context.executeFetchRequest(fetchRequest, error: &error)! as [NSManagedObject]
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
        let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
        let fetchRequest = NSFetchRequest(entityName: entityName)
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
        let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
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
    class func findFirstOrCreateWithAttribute(attribute: NSString!, value: NSString!, context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, handler: ((NSError!) -> Void)! = nil) -> NSManagedObject {
        let predicate = NSPredicate(format: "%K = %@", attribute,value)
        return findFirstOrCreateWithPredicate(predicate, context: context, handler)
    }
    
}