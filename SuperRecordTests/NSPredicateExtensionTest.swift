  //
//  NSPredicateExtensionTest.swift
//  SuperRecord
//
//  Created by Piergiuseppe Longo on 04/12/14.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import UIKit
import XCTest
import SuperRecord

class NSPredicateExtensionTest: SuperRecordTestCase {

    let firstLevelPredicate = NSPredicate(format: "level > 1")
    let secondLevelPredicate = NSPredicate (format: "level =< 36")
    
    let typePredicate = NSPredicate(format: "type.id = 1")
    let namePredicate = NSPredicate (format: "name == Charmender")
    
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
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
    }
    

    func testOrPredicate(){
        let expectedPredicate = NSPredicate (format: "level > 1 OR level =< 36");
        let resultPredicate = firstLevelPredicate | secondLevelPredicate;
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
    }
    
    func testAndPredicates(){
        var expectedPredicate = NSPredicate (format: "level > 1 AND name == Charmender AND level =< 36");
        var resultPredicate = [firstLevelPredicate, namePredicate] & [secondLevelPredicate];
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
        
        expectedPredicate = NSPredicate (format: "level > 1 AND name == Charmender AND level =< 36 AND type.id = 1");
        resultPredicate = [firstLevelPredicate, namePredicate] & [secondLevelPredicate, typePredicate];
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
        
    }
    
    func testOrPredicates(){
        var expectedPredicate = NSPredicate (format: "level > 1 OR name == Charmender OR level =< 36");
        var resultPredicate = [firstLevelPredicate, namePredicate] | [secondLevelPredicate];
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
        
        expectedPredicate = NSPredicate (format: "level > 1 OR name == Charmender OR level =< 36 OR type.id = 1");
        resultPredicate = [firstLevelPredicate, namePredicate] | [secondLevelPredicate, typePredicate];
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
        
    }
    
    func testMixedPredicates(){
        let expectedPredicate = NSPredicate (format: "level > 1 AND name == Charmender OR level =< 36");
        let resultPredicate = firstLevelPredicate & namePredicate | [secondLevelPredicate];
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
    }
    
    func testInitAnd(){
        var expectedPredicate = NSPredicate(firstPredicate: firstLevelPredicate, secondPredicate: secondLevelPredicate, predicateOperator: .And)
        var resultPredicate = NSPredicate(format: "(level > 1) AND (level =< 36)")
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);

        expectedPredicate = NSPredicate(firstPredicate: firstLevelPredicate, secondPredicate: secondLevelPredicate & namePredicate, predicateOperator: .And)
        resultPredicate = NSPredicate(format: "(level > 1) AND (level =< 36 AND name == Charmender)")
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
    }
    
    func testInitOr(){
        var expectedPredicate = NSPredicate(firstPredicate: firstLevelPredicate, secondPredicate: secondLevelPredicate, predicateOperator: .Or)
        var resultPredicate = NSPredicate(format: "(level > 1) OR (level =< 36)")
        
        expectedPredicate = NSPredicate(firstPredicate: firstLevelPredicate, secondPredicate: secondLevelPredicate & namePredicate, predicateOperator: .Or)
        resultPredicate = NSPredicate(format: "(level > 1) OR (level =< 36 AND name == Charmender)")

        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
    }

    func testPredicateValueIn(){
        let fireType = PokemonFactory.createType(managedObjectContext, id: .fire, name: .Fire)
        
        _ = PokemonFactory.createPokemon(managedObjectContext, id: .charmender, name: .Charmender, level: 1, type: fireType)
        _ = PokemonFactory.createPokemon(managedObjectContext, id: .charmeleon, name: .Charmeleon, level: 16, type: fireType)
        _ = PokemonFactory.createPokemon(managedObjectContext, id: .charizard, name: .Charizard, level: 36, type: fireType)
        
        var predicate = NSPredicate.predicateBuilder("name", value: ["Charmender", "Charizard"] as AnyObject, predicateOperator: .In)
        var count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(2, count, "Count mismatch")
        predicate = NSPredicate.predicateBuilder("level", value: [16] as AnyObject, predicateOperator: .In)
        count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(1, count, "Count mismatch")
    }
    
    func testPredicateEqualValue(){
        PokemonFactory.populate(managedObjectContext);
        let fireType = PokemonFactory.createType(managedObjectContext, id: .fire, name: .Fire)
        var predicate = NSPredicate.predicateBuilder("name", value: "Charmender" as AnyObject, predicateOperator: .Equal)
        var expectedPredicate = NSPredicate(format: "name == \"Charmender\"")
        var count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(1, count, "Count mismatch")
        
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        
        predicate = NSPredicate.predicateBuilder("level", value: 1 as AnyObject, predicateOperator: .Equal)
        expectedPredicate = NSPredicate(format: "level == 1")
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(3, count, "Count mismatch")
        
        predicate = NSPredicate.predicateBuilder("type", value: fireType, predicateOperator: .Equal)
        expectedPredicate = NSPredicate(format: "type == %@", fireType)
        checkPredicate(expectedPredicate, resultPredicate: predicate)

        count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(3, count, "Count mismatch")

    }
    
    func testPredicateNotEqualValue(){
        PokemonFactory.populate(managedObjectContext);
        let fireType = PokemonFactory.createType(managedObjectContext, id: .fire, name: .Fire)
        var predicate = NSPredicate.predicateBuilder("name", value: "Charmender" as AnyObject, predicateOperator: .NotEqual)
        var expectedPredicate = NSPredicate(format: "name != \"Charmender\"")
        var count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(8, count, "Count mismatch")
        
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        
        predicate = NSPredicate.predicateBuilder("level", value: 1 as AnyObject, predicateOperator: .NotEqual)
        expectedPredicate = NSPredicate(format: "level != 1")
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(6, count, "Count mismatch")
        
        predicate = NSPredicate.predicateBuilder("type", value: fireType, predicateOperator: .NotEqual)
        expectedPredicate = NSPredicate(format: "type != %@", fireType)
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(6, count, "Count mismatch")
        
    }
    
    func testPredicateGreaterThanValue(){
        PokemonFactory.populate(managedObjectContext);
        _ = PokemonFactory.createType(managedObjectContext, id: .fire, name: .Fire)
        var predicate = NSPredicate.predicateBuilder("level", value: 16 as AnyObject, predicateOperator: .GreaterThan)
        var expectedPredicate = NSPredicate(format: "level > 16")
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        var count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(3, count, "Count mismatch")
        
        predicate = NSPredicate.predicateBuilder("level", value: 16 as AnyObject, predicateOperator: .GreaterThanOrEqual)
        expectedPredicate = NSPredicate(format: "level >= 16")
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(6, count, "Count mismatch")
    }
    
    func testPredicateLessThanValue(){
        PokemonFactory.populate(managedObjectContext);
        _ = PokemonFactory.createType(managedObjectContext, id: .fire, name: .Fire)
        
        var predicate = NSPredicate.predicateBuilder("level", value: 16 as AnyObject, predicateOperator: .LessThan)
        var expectedPredicate = NSPredicate(format: "level < 16")
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        var count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(3, count, "Count mismatch")
        
        predicate = NSPredicate.predicateBuilder("level", value: 16 as AnyObject, predicateOperator: .LessThanOrEqual)
        expectedPredicate = NSPredicate(format: "level <= 16")
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(6, count, "Count mismatch")
    }
    
    
    func testPredicateContains(){
        PokemonFactory.populate(managedObjectContext);
        let predicate = NSPredicate.predicateBuilder("name", value: "char" as AnyObject, predicateOperator: .Contains)
        let expectedPredicate = NSPredicate(format: "name contains[c] \"char\"")
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        let count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(3, count, "Count mismatch")
    }

    
    fileprivate func checkPredicate(_ expectedPredicate : NSPredicate?, resultPredicate: NSPredicate?){
        XCTAssertNotNil(expectedPredicate, "Shouldn't be nil")
        XCTAssertNotNil(resultPredicate, "Shouldn't be nil")
        XCTAssertEqual(expectedPredicate!, resultPredicate!, "Predicates mismatch")
    }
    


}
