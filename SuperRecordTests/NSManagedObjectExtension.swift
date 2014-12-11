//
//  NSManagedObjectExtension.swift
//  SuperRecord
//
//  Created by Piergiuseppe Longo on 20/11/14.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import UIKit
import CoreData
import XCTest
import SuperRecord

class NSManagedObjectExtension: SuperRecordTestCase {
   
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //MARK: Entity creation
    
    func testCreateNewEntity() {

        let fireType = Type.createNewEntity(context: managedObjectContext) as Type;
        fireType.name = "Fire";
    
        let Charizard = Pokemon.createNewEntity(context: managedObjectContext) as Pokemon;

        Charizard.id = PokemonID.Charizard.rawValue
        Charizard.name = PokemonName.Charizard.rawValue
        Charizard.level = 36
        Charizard.type = fireType
    
        
        var expectation = expectationWithDescription("Charizard Creation")
        var result = Pokemon.findAllWithPredicate(nil, context: managedObjectContext,  completionHandler:{error in
            expectation.fulfill();
        })
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(result.count, 1,  "Should contains 1 pokemon");
        })
        
        let Charmender = Pokemon.createNewEntity(context: managedObjectContext) as Pokemon;
        expectation = expectationWithDescription("Charmender Creation")
        Charmender.id = PokemonID.Charmender.rawValue
        Charmender.name = PokemonName.Charmender.rawValue
        Charmender.level = 1
        Charmender.type = fireType

        result = Pokemon.findAllWithPredicate(nil, context: managedObjectContext,  completionHandler:{error in
            expectation.fulfill();
        })
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(result.count, 2,  "Should contains 2 pokemon");
        })
        
        XCTAssertEqual(fireType.pokemons.count, 2,  "Should contains 2 pokemon of this type");
        
        expectation = expectationWithDescription("Pokemon Deletion")
        Pokemon.deleteAll(context: managedObjectContext);
        result = Pokemon.findAllWithPredicate(nil, context: managedObjectContext,  completionHandler:{error in
            expectation.fulfill();
        })
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(result.count, 0,  "Should contains 0 pokemon");
        })
        
        XCTAssertEqual(fireType.pokemons.count, 0,  "Should contains 2 pokemon of this type");
    }
    
    func testFindFirstOrCreateWithAttribute(){

        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)
        let Charizard  = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: fireType);

        
        let charizardExpectation = expectationWithDescription("Charizard creation")
        let anotherCharizard  = Pokemon.findFirstOrCreateWithAttribute("name", value: "Charizard", context: managedObjectContext, handler:{error in
            charizardExpectation.fulfill()
        }) as Pokemon
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(Charizard, anotherCharizard, "Pokemon should be equals");
        })
        
        let Charmender  = Pokemon.findFirstOrCreateWithAttribute("name", value: "Charmender", context: managedObjectContext) as Pokemon;

        XCTAssertNotNil(Charmender, "Pokemon should be not nil")
        XCTAssertNotEqual(Charizard, Charmender, "Pokemon should mismatch")
        managedObjectContext.deleteObject(Charmender);
    }
    
    func testFindFirstOrCreateWithPredicate(){
        
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)
        let Charizard  = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: fireType);


        let predicate =  NSPredicate(format: "%K = %@", "name","Charizard")
        let charizardExpectation = expectationWithDescription("Charizard creation")
        let anotherCharizard  = Pokemon.findFirstOrCreateWithPredicate(predicate, context: managedObjectContext, handler:{error in
            charizardExpectation.fulfill()
        }) as Pokemon
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(Charizard, anotherCharizard, "Pokemon should be equals");
        })
        
        XCTAssertEqual(1, Pokemon.count(context: managedObjectContext, predicate: nil, error: nil), "Count mismatch")
        XCTAssertEqual(1, Type.count(context: managedObjectContext, predicate: nil, error: nil), "Count mismatch")
        
        let charmenderExpectation = expectationWithDescription("Charmender creation")
        let charmenderPredicate = NSPredicate(format: "%K = %@", "name", "Charmender")

        let Charmender  = Pokemon.findFirstOrCreateWithPredicate(charmenderPredicate, context: managedObjectContext, handler:{error in
            charmenderExpectation.fulfill();
        }) as Pokemon;
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertNotNil(Charmender, "Pokemon should be not nil")
            XCTAssertNotEqual(Charizard, Charmender, "Pokemon should mismatch")
        })
        
        managedObjectContext.deleteObject(Charmender);
        
    }
    
    //MARK: Entity search
    
    func testFindAll(){
    
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)

        let charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: fireType);
        let charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: fireType);
        let charizard  = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: fireType);
        
        var pokemons = Pokemon.findAll(context: managedObjectContext)
        
        XCTAssertEqual(3, pokemons.count, "Should contains 3 pokemons");
        XCTAssertTrue(pokemons.containsObject( charmender), "Should contains pokemon");
        XCTAssertTrue(pokemons.containsObject(charmeleon), "Should contains pokemon");
        XCTAssertTrue(pokemons.containsObject(charizard), "Should contains pokemon");
        
    }
    
    func testFindAllWithAttribute(){
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)

        let charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: fireType);
        let charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: fireType);
        let charizard  = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: fireType);

        
        var pokemons = Pokemon.findAllWithAttribute("name", value: charizard.name, context: managedObjectContext)
        XCTAssertEqual(1, pokemons.count, "Should contains 1 pokemons");

    }
    
    func testFindAllWithPredicate(){
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)

        let charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: fireType);
        let charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: fireType);
        let charizard  = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: fireType);

        var predicate = NSPredicate (format: "level == %d", 36)
        var pokemons = Pokemon.findAllWithPredicate(predicate, context: managedObjectContext, completionHandler: nil)
        XCTAssertEqual(1, pokemons.count, "Should contains 1 pokemons");
    }
    
    func testCountWithPredicate(){
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)

        let charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: fireType);
        let charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: fireType);
        let charizard  = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: fireType);
        
        var pokemonCount = Pokemon.countWithPredicate(nil, context: managedObjectContext, completionHandler: nil)
        XCTAssertEqual(3, pokemonCount, "Count Should return 3 pokemons");
    }
    
    //MARK: Entity deletion
    
    func testDeleteAll(){
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)

        let charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: fireType);
        let charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: fireType);
        let charizard  = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: fireType);

        var pokemons = Pokemon.findAll (context: managedObjectContext);
        XCTAssertEqual(3, pokemons.count, "Should contains 3 pokemons");
        Pokemon.deleteAll(context: managedObjectContext);
        pokemons = Pokemon.findAll (context: managedObjectContext);
        XCTAssertEqual(0, pokemons.count, "Should contains 3 pokemons");
    }
    
    func testDeleteAllWithPredicate(){
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)

        let charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: fireType);
        let charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: fireType);
        let charizard  = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: fireType);

        var pokemons = Pokemon.findAll (context: managedObjectContext);
        XCTAssertEqual(3, pokemons.count, "Should contains 3 pokemons");
        var predicate = NSPredicate (format: "level == %d", 36)
        Pokemon.deleteAll(predicate, context: managedObjectContext)
        pokemons = Pokemon.findAll (context: managedObjectContext)
        XCTAssertEqual(2, pokemons.count, "Should contains 3 pokemons")

    }
    
    //MARK: Entity operations
    
    func testCount(){
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)
        let waterType = PokemonFactory.createType(managedObjectContext, id: .Water, name: .Water)


        let Charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: fireType)
        let Charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: fireType)
        let Charizard = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: fireType)
        let Blastoise = PokemonFactory.createPokemon(managedObjectContext, id: .Blastoise, name: .Blastoise, level: 36, type: waterType)

        XCTAssertEqual(2, Type.count(context: managedObjectContext, predicate: nil, error: nil), "Count mismatch")
        
        XCTAssertEqual(4, Pokemon.count(context: managedObjectContext, predicate: nil, error: nil), "Count mismatch")
        var levelPredicate = NSPredicate(format: "level > 6");
        
        XCTAssertEqual(3, Pokemon.count(context: managedObjectContext, predicate: levelPredicate!,  error: nil), "Count mismatch")
        
        levelPredicate = NSPredicate(format: "level > 36");
        XCTAssertEqual(0, Pokemon.count(context: managedObjectContext, predicate: levelPredicate!,  error: nil), "Count mismatch")
        
        var typePredicate = NSPredicate(format: "%K = %@", "type", fireType);
        XCTAssertEqual(3, Pokemon.count(context: managedObjectContext, predicate: typePredicate!,  error: nil),  "Count mismatch")

    }
    
    
    func testSum(){
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)
        let waterType = PokemonFactory.createType(managedObjectContext, id: .Water, name: .Water)
    
        let Charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: fireType)
        let Charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: fireType)
        let Charizard = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: fireType)
        let Blastoise = PokemonFactory.createPokemon(managedObjectContext, id: .Blastoise, name: .Blastoise, level: 36, type: waterType)
        managedObjectContext.save(&error)
        var expectation = expectationWithDescription("Sum")
        var sumLevel = Pokemon.sum(context:managedObjectContext, fieldName: "level", predicate: nil, handler:{error in
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
        XCTAssertEqual(89, sumLevel, "Count mismatch")
        })
        
        let sumsExpectation = expectationWithDescription("Sum")
        var sumsLevel = Pokemon.sum(context:managedObjectContext, fieldName: ["level", "id"], predicate: nil,  handler:{error in
            sumsExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(89, sumsLevel[0], "Count mismatch")
            XCTAssertEqual(24, sumsLevel[1], "Count mismatch")
        })

    }
    
    func testMax(){
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)
        let waterType = PokemonFactory.createType(managedObjectContext, id: .Water, name: .Water)
        
        let Charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: fireType)
        let Charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: fireType)
        let Charizard = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: fireType)
        let Blastoise = PokemonFactory.createPokemon(managedObjectContext, id: .Blastoise, name: .Blastoise, level: 36, type: waterType)
        
        managedObjectContext.save(&error)
        var expectation = expectationWithDescription("Max")
        var max = Pokemon.max(context:managedObjectContext, fieldName: ["level"], predicate: nil, handler:{error in
            expectation.fulfill()
        }).first as Double!
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(36, max, "Count mismatch")
        })
        
        expectation = expectationWithDescription("Max")
        max = Pokemon.max(context:managedObjectContext, fieldName: "level", predicate: nil, handler:{error in
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(36, max, "Count mismatch")
        })
        
        expectation = expectationWithDescription("Max")
        max = Pokemon.max(context:managedObjectContext, fieldName: "level", predicate: NSPredicate(format: "level < 5"), handler:{error in
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(1, max, "Count mismatch")
        })

    }
    
    func testMin(){
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)
        let waterType = PokemonFactory.createType(managedObjectContext, id: .Water, name: .Water)
        
        let Charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: fireType)
        let Charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: fireType)
        let Charizard = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: fireType)
        let Blastoise = PokemonFactory.createPokemon(managedObjectContext, id: .Blastoise, name: .Blastoise, level: 36, type: waterType)
        
        managedObjectContext.save(&error)
        var expectation = expectationWithDescription("min")
        var min = Pokemon.min(context:managedObjectContext, fieldName: ["level"], predicate: nil, handler:{error in
            expectation.fulfill()
        }).first as Double!
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(1, min, "Count mismatch")
        })
        
        expectation = expectationWithDescription("min")
        min = Pokemon.min(context:managedObjectContext, fieldName: "level", predicate: nil, handler:{error in
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(1, min, "Count mismatch")
        })
        
        expectation = expectationWithDescription("min")
        min = Pokemon.min(context:managedObjectContext, fieldName: "level", predicate: NSPredicate(format: "level >= 6"), handler:{error in
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(16, min, "Count mismatch")
        })
        
    }

    func testAvg(){
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)
        let waterType = PokemonFactory.createType(managedObjectContext, id: .Water, name: .Water)
        
        let Charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: fireType)
        let Charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: fireType)
        let Charizard = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: fireType)
        let Blastoise = PokemonFactory.createPokemon(managedObjectContext, id: .Blastoise, name: .Blastoise, level: 36, type: waterType)
        
        managedObjectContext.save(&error)
        var expectation = expectationWithDescription("avg")
        var avg = Pokemon.avg(context:managedObjectContext, fieldName: ["level"], predicate: nil, handler:{error in
            expectation.fulfill()
        }).first as Double!
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(22.25, avg, "Count mismatch")
        })
        
        expectation = expectationWithDescription("avg")
        avg = Pokemon.avg(context:managedObjectContext, fieldName: "level", predicate: nil, handler:{error in
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(22.25, avg, "Count mismatch")
        })
        
        expectation = expectationWithDescription("avg")
        avg = Pokemon.avg(context:managedObjectContext, fieldName: "level", predicate: NSPredicate(format: "level >= 6"), handler:{error in
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(88/3, avg, "Count mismatch")
        })
        
    }


    

}
