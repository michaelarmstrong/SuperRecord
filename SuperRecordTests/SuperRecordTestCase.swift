//
//  SuperRecordTestsTestCase.swift
//  SuperRecord
//
//  Created by Piergiuseppe Longo on 18/11/14.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import UIKit
import CoreData
import XCTest
import SuperRecord

let SuperRecordTestCaseTimeout : NSTimeInterval = 5



class SuperRecordTestCase: XCTestCase {
    
    var managedObjectContext  = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
    var error: NSError? = nil
    
    let applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls.last as! NSURL
        }()



    override func setUp() {
        super.setUp();
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Pokemon.sqlite")
        NSFileManager.defaultManager().removeItemAtURL(url, error: nil)
        var error: NSError? = nil
        var mom : NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(NSBundle.allBundles())!;
        var psc : NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mom);
        var ps : NSPersistentStore = psc.addPersistentStoreWithType(
            NSSQLiteStoreType,
            configuration: nil,
            URL: url,
            options: nil,
            error: &error)!
        if ((error) != nil)
        {
            XCTFail("Error creating NSPersistentStore");
        }
        
        XCTAssertGreaterThan(mom.entities.count, 0, "Should contains entities");
        mom.entities.count
        
        managedObjectContext.persistentStoreCoordinator = psc
        error = nil;

    }
    
    override func tearDown() {

        managedObjectContext.save(&error);
        if(error != nil){
            XCTFail("Cannot save context: \(error?.localizedDescription)");
        }
        super.tearDown();
    }
   
}
