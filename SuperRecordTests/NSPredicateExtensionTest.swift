  //
//  NSPredicateExtensionTest.swift
//  SuperRecord
//
//  Created by Piergiuseppe Longo on 04/12/14.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import UIKit
import XCTest

class NSPredicateExtensionTest: SuperRecordTestCase {

    let firstLevelPredicate = NSPredicate(format: "level > 1")!
    let secondLevelPredicate = NSPredicate (format: "level =< 36")!
    
    let typePredicate = NSPredicate(format: "type.id = 1")!
    let namePredicate = NSPredicate (format: "name == Charmender")!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testAndPredicate(){
        let expectedPredicate = NSPredicate (format: "level > 1 AND level =< 36");
        let resultPredicate = firstLevelPredicate & secondLevelPredicate;
        checkPreficate(expectedPredicate, resultPredicate: resultPredicate);
    }
    

    func testOrPredicate(){
        let expectedPredicate = NSPredicate (format: "level > 1 OR level =< 36");
        let resultPredicate = firstLevelPredicate | secondLevelPredicate;
        checkPreficate(expectedPredicate, resultPredicate: resultPredicate);
    }
    
    func testAndPredicates(){
        var expectedPredicate = NSPredicate (format: "level > 1 AND name == Charmender AND level =< 36");
        var resultPredicate = [firstLevelPredicate, namePredicate] & [secondLevelPredicate];
        checkPreficate(expectedPredicate, resultPredicate: resultPredicate);
        
        expectedPredicate = NSPredicate (format: "level > 1 AND name == Charmender AND level =< 36 AND type.id = 1");
        resultPredicate = [firstLevelPredicate, namePredicate] & [secondLevelPredicate, typePredicate];
        checkPreficate(expectedPredicate, resultPredicate: resultPredicate);
        
    }
    
    func testOrPredicates(){
        var expectedPredicate = NSPredicate (format: "level > 1 OR name == Charmender OR level =< 36");
        var resultPredicate = [firstLevelPredicate, namePredicate] | [secondLevelPredicate];
        checkPreficate(expectedPredicate, resultPredicate: resultPredicate);
        
        expectedPredicate = NSPredicate (format: "level > 1 OR name == Charmender OR level =< 36 OR type.id = 1");
        resultPredicate = [firstLevelPredicate, namePredicate] | [secondLevelPredicate, typePredicate];
        checkPreficate(expectedPredicate, resultPredicate: resultPredicate);
        
    }
    
    func testMixedPredicates(){
        var expectedPredicate = NSPredicate (format: "level > 1 AND name == Charmender OR level =< 36");
        var resultPredicate = firstLevelPredicate & namePredicate | [secondLevelPredicate];
        checkPreficate(expectedPredicate, resultPredicate: resultPredicate);
    }
    
    func testInitAnd(){
        var expectedPredicate = NSPredicate(firstPredicate: firstLevelPredicate, secondPredicate: secondLevelPredicate, predicateOperator: NSPredicateOperator.And)
        var resultPredicate = NSPredicate(format: "(level > 1) AND (level =< 36)")
        checkPreficate(expectedPredicate, resultPredicate: resultPredicate);

        expectedPredicate = NSPredicate(firstPredicate: firstLevelPredicate, secondPredicate: secondLevelPredicate & namePredicate, predicateOperator: NSPredicateOperator.And)
        resultPredicate = NSPredicate(format: "(level > 1) AND (level =< 36 AND name == Charmender)")
        checkPreficate(expectedPredicate, resultPredicate: resultPredicate);
    }
    
    func testInitOr(){
        var expectedPredicate = NSPredicate(firstPredicate: firstLevelPredicate, secondPredicate: secondLevelPredicate, predicateOperator: NSPredicateOperator.Or)
        var resultPredicate = NSPredicate(format: "(level > 1) OR (level =< 36)")
        
        expectedPredicate = NSPredicate(firstPredicate: firstLevelPredicate, secondPredicate: secondLevelPredicate & namePredicate, predicateOperator: NSPredicateOperator.Or)
        resultPredicate = NSPredicate(format: "(level > 1) OR (level =< 36 AND name == Charmender)")

        checkPreficate(expectedPredicate, resultPredicate: resultPredicate);
    }

    func testPredicateValueIn(){
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)
        let Charmender = PokemonFactory.createPokemon(managedObjectContext, id: .Charmender, name: .Charmender, level: 1, type: fireType)
        let Charmeleon = PokemonFactory.createPokemon(managedObjectContext, id: .Charmeleon, name: .Charmeleon, level: 16, type: fireType)
        let Charizard = PokemonFactory.createPokemon(managedObjectContext, id: .Charizard, name: .Charizard, level: 36, type: fireType)
        var predicate = NSPredicate.predicateBuilder("name", value: ["Charmender", "Charizard"], predicateOperator: .In)
        var count = Pokemon.count(context: managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(2, count, "Count mismatch")
        predicate = NSPredicate.predicateBuilder("level", value: [16], predicateOperator: .In)
        count = Pokemon.count(context: managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(1, count, "Count mismatch")

    }
    
    func testPredicateEqualValue(){
        PokemonFactory.populate(managedObjectContext);
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)
        var predicate = NSPredicate.predicateBuilder("name", value: "Charmender", predicateOperator: .Equal)
        var expectedPredicate = NSPredicate(format: "name == \"Charmender\"")
        var count = Pokemon.count(context: managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(1, count, "Count mismatch")
        
        checkPreficate(expectedPredicate, resultPredicate: predicate)
        
        predicate = NSPredicate.predicateBuilder("level", value: 1, predicateOperator: .Equal)
        expectedPredicate = NSPredicate(format: "level == 1")
        checkPreficate(expectedPredicate, resultPredicate: predicate)
        count = Pokemon.count(context: managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(3, count, "Count mismatch")
        
        predicate = NSPredicate.predicateBuilder("type", value: fireType, predicateOperator: .Equal)
        expectedPredicate = NSPredicate(format: "type == %@", fireType)
        checkPreficate(expectedPredicate, resultPredicate: predicate)

        count = Pokemon.count(context: managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(3, count, "Count mismatch")

    }
    
    func testPredicateNotEqualValue(){
        PokemonFactory.populate(managedObjectContext);
        let fireType = PokemonFactory.createType(managedObjectContext, id: .Fire, name: .Fire)
        var predicate = NSPredicate.predicateBuilder("name", value: "Charmender", predicateOperator: .NotEqual)
        var expectedPredicate = NSPredicate(format: "name != \"Charmender\"")
        var count = Pokemon.count(context: managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(8, count, "Count mismatch")
        
        checkPreficate(expectedPredicate, resultPredicate: predicate)
        
        predicate = NSPredicate.predicateBuilder("level", value: 1, predicateOperator: .NotEqual)
        expectedPredicate = NSPredicate(format: "level != 1")
        checkPreficate(expectedPredicate, resultPredicate: predicate)
        count = Pokemon.count(context: managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(6, count, "Count mismatch")
        
        predicate = NSPredicate.predicateBuilder("type", value: fireType, predicateOperator: .NotEqual)
        expectedPredicate = NSPredicate(format: "type != %@", fireType)
        checkPreficate(expectedPredicate, resultPredicate: predicate)
        count = Pokemon.count(context: managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(6, count, "Count mismatch")
        
    }

    
    private func checkPreficate(expectedPredicate : NSPredicate?, resultPredicate: NSPredicate?){
        XCTAssertNotNil(expectedPredicate, "Shouldn't be nil")
        XCTAssertNotNil(resultPredicate, "Shouldn't be nil")
        XCTAssertEqual(expectedPredicate!, resultPredicate!, "Predicates mismatch")
    }
    


}
