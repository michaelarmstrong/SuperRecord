//
//  NSManagedObjectExtension.swift
//
//  A small set of utilities to make working with CoreData a bit easier.
//  http://mike.kz/
//
//  Created by Michael Armstrong on 12/10/2014.
//  Copyright (c) 2014 SuperArmstrong.UK. All rights reserved.
//
//  RESPONSIBILITY : Several helpers for NSManagedObject to make common operations simpler.

import CoreData

extension NSManagedObject {

    class func findAllWithPredicate(predicate: NSPredicate!, context: NSManagedObjectContext) -> NSArray {
        let entityName : NSString = NSStringFromClass(self)
        let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.entity = entityDescription
        var results = NSArray()
        context.performBlockAndWait({ () -> Void in
            var error : NSError?
            results = context.executeFetchRequest(fetchRequest, error: &error)!
        })
        return results
    }
    
    class func findAllWithPredicate(predicate: NSPredicate!) -> NSArray {
        let context = CoreDataStack.defaultStack.managedObjectContext!
        return findAllWithPredicate(nil, context: context)
    }

    class func deleteAll(context: NSManagedObjectContext) -> Void {
        let results = findAll(context)
        for result in results {
            context.deleteObject(result as NSManagedObject)
        }
    }
    
    class func findAll(context: NSManagedObjectContext) -> NSArray {
        return findAllWithPredicate(nil, context: context)
    }
    
    class func findAll() -> NSArray {
        let context = CoreDataStack.defaultStack.managedObjectContext!
        return findAllWithPredicate(nil, context: context)
    }
    
    class func findAllWithAttribute(attribute: NSString!, value: NSString!, context: NSManagedObjectContext) -> NSArray {
        let predicate = NSPredicate(format: "%K = %@", attribute,value)
        return findAllWithPredicate(predicate, context: context)
    }
    
    class func findFirstOrCreateWithPredicate(predicate: NSPredicate!) -> NSManagedObject {
        let context = CoreDataStack.defaultStack.managedObjectContext!
        return findFirstOrCreateWithPredicate(predicate, context: context)
    }
    
    class func findFirstOrCreateWithPredicate(predicate: NSPredicate!, context: NSManagedObjectContext) -> NSManagedObject {
        let entityName : NSString = NSStringFromClass(self)
        let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        fetchRequest.entity = entityDescription
        var results = NSArray()
        context.performBlockAndWait({ () -> Void in
            var error : NSError?
            results = context.executeFetchRequest(fetchRequest, error: &error)!
        })
        for result in results {
            return result as NSManagedObject
        }
        
        var obj = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: context)
        return obj
    }
    
    class func findFirstOrCreateWithAttribute(attribute: NSString!, value: NSString!, context: NSManagedObjectContext) -> NSManagedObject {
        let predicate = NSPredicate(format: "%K = %@", attribute,value)
        return findFirstOrCreateWithPredicate(predicate, context: context)
    }
    
    class func findFirstOrCreateWithAttribute(attribute: NSString!, value: NSString!) -> NSManagedObject {
        let context = CoreDataStack.defaultStack.managedObjectContext!
        return findFirstOrCreateWithAttribute(attribute, value: value, context: context)
    }
}