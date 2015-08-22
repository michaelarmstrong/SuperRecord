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
        return urls.last!
        }()



    override func setUp() {
        super.setUp();
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Pokemon.sqlite")
        do {
            try NSFileManager.defaultManager().removeItemAtURL(url)
        } catch _ {
        }
        var error: NSError? = nil
        let mom : NSManagedObjectModel = NSManagedObjectModel.mergedModelFromBundles(NSBundle.allBundles())!;
        let psc : NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mom);
        var ps : NSPersistentStore = try! psc.addPersistentStoreWithType(
            NSSQLiteStoreType,
            configuration: nil,
            URL: url,
            options: nil)
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

        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
        };
        if(error != nil){
            XCTFail("Cannot save context: \(error?.localizedDescription)");
        }
        super.tearDown();
    }
   
}
