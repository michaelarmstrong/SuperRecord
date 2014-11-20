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


class SuperRecordTestCase: XCTestCase {
    
    var managedObjectContext  = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)

    override func setUp() {
        super.setUp();
        var error: NSError? = nil
        var mom : NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(NSBundle.allBundles())!;
        var psc : NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mom);
        var ps : NSPersistentStore = psc.addPersistentStoreWithType(
            NSInMemoryStoreType,
            configuration: nil,
            URL: nil,
            options: nil,
            error: &error)!
        if ((error) != nil)
        {
            XCTFail("Error creating NSPersistentStore");
        }
        
        XCTAssertGreaterThan(mom.entities.count, 0, "Should contains entities");
        mom.entities.count
        
        managedObjectContext.persistentStoreCoordinator = psc

    }
   
}
