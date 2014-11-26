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
    
    //MARK: Entity Creation
    
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


        let Charizard  = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: .Fire);

        
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
        
        let Charizard  = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: .Fire);

    
        let predicate =  NSPredicate(format: "%K = %@", "name","Charizard")
        let charizardExpectation = expectationWithDescription("Charizard creation")
        let anotherCharizard  = Pokemon.findFirstOrCreateWithPredicate(predicate, context: managedObjectContext, handler:{error in
            charizardExpectation.fulfill()
        }) as Pokemon
        
        waitForExpectationsWithTimeout(SuperRecordTestCaseTimeout, handler: { error in
            XCTAssertEqual(Charizard, anotherCharizard, "Pokemon should be equals");
        })
        
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
    
    //MARK: Entity Search
    
    func testFindAll(){
    
        let charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: .Fire);
        let charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: .Fire);
        let charizard  = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: .Fire);
        
        var pokemons = Pokemon.findAll(context: managedObjectContext)
        
        XCTAssertEqual(3, pokemons.count, "Should contains 3 pokemons");
        XCTAssertTrue(pokemons.containsObject( charmender), "Should contains pokemon");
        XCTAssertTrue(pokemons.containsObject(charmeleon), "Should contains pokemon");
        XCTAssertTrue(pokemons.containsObject(charizard), "Should contains pokemon");
        
    }
    
    func testFindAllWithAttribute(){
        
        let charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: .Fire);
        let charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: .Fire);
        let charizard  = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: .Fire);

        
        var pokemons = Pokemon.findAllWithAttribute("name", value: charizard.name, context: managedObjectContext)
        XCTAssertEqual(1, pokemons.count, "Should contains 1 pokemons");

    }
    
    func testFindAllWithPredicate(){
        
        let charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: .Fire);
        let charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: .Fire);
        let charizard  = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: .Fire);

        var predicate = NSPredicate (format: "level == %d", 36)
        var pokemons = Pokemon.findAllWithPredicate(predicate, context: managedObjectContext, completionHandler: nil)
        XCTAssertEqual(1, pokemons.count, "Should contains 1 pokemons");
    }
    
    //MARK: Entity Deletion
    
    func testDeleteAll(){
        let charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: .Fire);
        let charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: .Fire);
        let charizard  = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: .Fire);

        var pokemons = Pokemon.findAll (context: managedObjectContext);
        XCTAssertEqual(3, pokemons.count, "Should contains 3 pokemons");
        Pokemon.deleteAll(context: managedObjectContext);
        pokemons = Pokemon.findAll (context: managedObjectContext);
        XCTAssertEqual(0, pokemons.count, "Should contains 3 pokemons");
    }
    
    func testDeleteAllWithPredicate(){
        let charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: .Fire);
        let charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: .Fire);
        let charizard  = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: .Fire);

        var pokemons = Pokemon.findAll (context: managedObjectContext);
        XCTAssertEqual(3, pokemons.count, "Should contains 3 pokemons");
        var predicate = NSPredicate (format: "level == %d", 36)
        Pokemon.deleteAll(predicate, context: managedObjectContext)
        pokemons = Pokemon.findAll (context: managedObjectContext)
        XCTAssertEqual(2, pokemons.count, "Should contains 3 pokemons")

    }

}
