//
//  SuperCoreDataStack.swift
//
//  SuperRecord - A small set of utilities to make working with CoreData a bit easier.
//  http://mike.kz/
//
//  Created by Michael Armstrong on 12/10/2014.
//  Copyright (c) 2014 SuperArmstrong.UK. All rights reserved.
//
//  RESPONSIBILITY : Setup a CoreData Stack accessible via a singleton.
//
//  NOTE: !!This Boiler Plate singleton is experimental and a work in progress!!

import UIKit
import CoreData

let infoDictionary = Bundle.main.infoDictionary as NSDictionary?
let stackName = (infoDictionary!["CFBundleName"]! as AnyObject).replacingOccurrences(of: " ", with: "_")

// Set this var to override the default CFBundleName assumption.
var storeName = stackName + ".sqlite"

public let applicationDocumentsDirectory: URL = {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls.last!
    }()

open class SuperCoreDataStack: NSObject {
    
    let persistentStoreURL : URL?
    let storeType : NSString
    
    //TODO: Move away from this pattern so developers can use their own stack name and specify store type.
    open class var defaultStack : SuperCoreDataStack {
    struct DefaultStatic {
            static let instance : SuperCoreDataStack = SuperCoreDataStack(storeType:NSSQLiteStoreType as NSString,storeURL: applicationDocumentsDirectory.appendingPathComponent(storeName))
        }
        return DefaultStatic.instance
    }
    
    open class var inMemoryStack : SuperCoreDataStack {
        struct InMemoryStatic {
            static let instance : SuperCoreDataStack = SuperCoreDataStack(storeType:NSInMemoryStoreType as NSString,storeURL:nil)
        }
        return InMemoryStatic.instance
    }
    
    init(storeType: NSString, storeURL: URL?) {
        self.persistentStoreURL = storeURL
        self.storeType = storeType
        
        super.init()
    }
    
    open func importSqliteFile(_ sqliteFileName: String, shouldOverride: Bool){
        let fileManager = FileManager.default;
        if let path = persistentStoreURL?.path {
            if ( fileManager.fileExists(atPath: path) ){
                guard shouldOverride else {return}
                try! fileManager.removeItem(atPath: path)
            }
            if let sqlitePath  = Bundle.main.path(forResource: sqliteFileName, ofType: "sqlite"){
                try! fileManager.copyItem(atPath: sqlitePath, toPath: path)
            }
        }
    }
    

       // MARK: - Core Data stack
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: stackName, withExtension: "momd")
        return NSManagedObjectModel(contentsOf: modelURL!)!
        }()
    
    //TODO : Implement better error handling around this boilerplate and implement in memory store types.
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
      //  let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(storeName)
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            try coordinator!.addPersistentStore(ofType: self.storeType as String, configurationName: nil, at: self.persistentStoreURL, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error            
            error = NSError(domain: "com.superrecord.error.domain", code: 9999, userInfo: dict)
            
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
        }()
    
    open lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    open func saveContext () {
        //TODO: Improve error handling.
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }

    
}
