//
//  SuperRecordTests.swift
//  SuperRecordTests
//
//  Created by Michael Armstrong on 24/10/2014.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//
//TODO : Write some tests (currently having an issue with tests within a framework)

import UIKit
import XCTest
import CoreData
import SuperRecord

class SuperRecordTests: SuperRecordTestCase {
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate() {
        var error: NSError? = nil
        
        let fireType = Type.createNewEntity(managedObjectContext) as Type;
        fireType.name = "Fire";
        
        managedObjectContext.save(&error);
        if(error != nil){
            XCTFail("Cannot save context");
        }
        
        let Charizard = Pokemon.createNewEntity(managedObjectContext) as Pokemon;
        Charizard.name = "Charizard";
        Charizard.level = 10;
        Charizard.type = fireType;
        managedObjectContext.save(&error);
        if(error != nil){
            XCTFail("Cannot save context");
        }
        
        var expectation = expectationWithDescription("Pokemon Creation")
        var result = Pokemon.findAllWithPredicate(nil, context: managedObjectContext,  completionHandler:{error in
            expectation.fulfill();
        })
        
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertEqual(result.count, 1,  "Result");
        })
        
        let charmender = Pokemon.createNewEntity(managedObjectContext) as Pokemon;
        expectation = expectationWithDescription("Pokemon Creation")
        charmender.name = "charmender";
        charmender.level = 1;
        charmender.type = fireType;
        
        managedObjectContext.save(&error);
        if(error != nil){
            XCTFail("Cannot save context");
        }
        
        result = Pokemon.findAllWithPredicate(nil, context: managedObjectContext,  completionHandler:{error in
            expectation.fulfill();
        })
        
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertEqual(result.count, 2,  "Result");
        })
        
        XCTAssertEqual(fireType.pokemons.count, 2,  "Result");
        
        expectation = expectationWithDescription("Pokemon Deletion")
        Pokemon.deleteAll(context: managedObjectContext);
        result = Pokemon.findAllWithPredicate(nil, context: managedObjectContext,  completionHandler:{error in
            expectation.fulfill();
        })
        
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertEqual(result.count, 0,  "Result");
        })
        
    }
    
}
