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

    let firstLevelPredicate = Predicate(format: "level > 1")
    let secondLevelPredicate = Predicate (format: "level =< 36")
    
    let typePredicate = Predicate(format: "type.id = 1")
    let namePredicate = Predicate (format: "name == Charmender")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testAndPredicate(){
        let expectedPredicate = Predicate (format: "level > 1 AND level =< 36");
        let resultPredicate = firstLevelPredicate & secondLevelPredicate;
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
    }
    

    func testOrPredicate(){
        let expectedPredicate = Predicate (format: "level > 1 OR level =< 36");
        let resultPredicate = firstLevelPredicate | secondLevelPredicate;
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
    }
    
    func testAndPredicates(){
        var expectedPredicate = Predicate (format: "level > 1 AND name == Charmender AND level =< 36");
        var resultPredicate = [firstLevelPredicate, namePredicate] & [secondLevelPredicate];
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
        
        expectedPredicate = Predicate (format: "level > 1 AND name == Charmender AND level =< 36 AND type.id = 1");
        resultPredicate = [firstLevelPredicate, namePredicate] & [secondLevelPredicate, typePredicate];
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
        
    }
    
    func testOrPredicates(){
        var expectedPredicate = Predicate (format: "level > 1 OR name == Charmender OR level =< 36");
        var resultPredicate = [firstLevelPredicate, namePredicate] | [secondLevelPredicate];
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
        
        expectedPredicate = Predicate (format: "level > 1 OR name == Charmender OR level =< 36 OR type.id = 1");
        resultPredicate = [firstLevelPredicate, namePredicate] | [secondLevelPredicate, typePredicate];
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
        
    }
    
    func testMixedPredicates(){
        let expectedPredicate = Predicate (format: "level > 1 AND name == Charmender OR level =< 36");
        let resultPredicate = firstLevelPredicate & namePredicate | [secondLevelPredicate];
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
    }
    
    func testInitAnd(){
        var expectedPredicate = Predicate(firstPredicate: firstLevelPredicate, secondPredicate: secondLevelPredicate, predicateOperator: .And)
        var resultPredicate = Predicate(format: "(level > 1) AND (level =< 36)")
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);

        expectedPredicate = Predicate(firstPredicate: firstLevelPredicate, secondPredicate: secondLevelPredicate & namePredicate, predicateOperator: .And)
        resultPredicate = Predicate(format: "(level > 1) AND (level =< 36 AND name == Charmender)")
        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
    }
    
    func testInitOr(){
        var expectedPredicate = Predicate(firstPredicate: firstLevelPredicate, secondPredicate: secondLevelPredicate, predicateOperator: .Or)
        var resultPredicate = Predicate(format: "(level > 1) OR (level =< 36)")
        
        expectedPredicate = Predicate(firstPredicate: firstLevelPredicate, secondPredicate: secondLevelPredicate & namePredicate, predicateOperator: .Or)
        resultPredicate = Predicate(format: "(level > 1) OR (level =< 36 AND name == Charmender)")

        checkPredicate(expectedPredicate, resultPredicate: resultPredicate);
    }

    func testPredicateValueIn(){
        let fireType = PokemonFactory.createType(managedObjectContext, id: .fire, name: .Fire)
        
        PokemonFactory.createPokemon(managedObjectContext, id: .charmender, name: .Charmender, level: 1, type: fireType)
        PokemonFactory.createPokemon(managedObjectContext, id: .charmeleon, name: .Charmeleon, level: 16, type: fireType)
        PokemonFactory.createPokemon(managedObjectContext, id: .charizard, name: .Charizard, level: 36, type: fireType)
        
        var predicate = Predicate.predicateBuilder("name", value: ["Charmender", "Charizard"], predicateOperator: .In)
        var count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(2, count, "Count mismatch")
        predicate = Predicate.predicateBuilder("level", value: [16], predicateOperator: .In)
        count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(1, count, "Count mismatch")
    }
    
    func testPredicateEqualValue(){
        PokemonFactory.populate(managedObjectContext);
        let fireType = PokemonFactory.createType(managedObjectContext, id: .fire, name: .Fire)
        var predicate = Predicate.predicateBuilder("name", value: "Charmender", predicateOperator: .Equal)
        var expectedPredicate = Predicate(format: "name == \"Charmender\"")
        var count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(1, count, "Count mismatch")
        
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        
        predicate = Predicate.predicateBuilder("level", value: 1, predicateOperator: .Equal)
        expectedPredicate = Predicate(format: "level == 1")
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(3, count, "Count mismatch")
        
        predicate = Predicate.predicateBuilder("type", value: fireType, predicateOperator: .Equal)
        expectedPredicate = Predicate(format: "type == %@", fireType)
        checkPredicate(expectedPredicate, resultPredicate: predicate)

        count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(3, count, "Count mismatch")

    }
    
    func testPredicateNotEqualValue(){
        PokemonFactory.populate(managedObjectContext);
        let fireType = PokemonFactory.createType(managedObjectContext, id: .fire, name: .Fire)
        var predicate = Predicate.predicateBuilder("name", value: "Charmender", predicateOperator: .NotEqual)
        var expectedPredicate = Predicate(format: "name != \"Charmender\"")
        var count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(8, count, "Count mismatch")
        
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        
        predicate = Predicate.predicateBuilder("level", value: 1, predicateOperator: .NotEqual)
        expectedPredicate = Predicate(format: "level != 1")
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(6, count, "Count mismatch")
        
        predicate = Predicate.predicateBuilder("type", value: fireType, predicateOperator: .NotEqual)
        expectedPredicate = Predicate(format: "type != %@", fireType)
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(6, count, "Count mismatch")
        
    }
    
    func testPredicateGreaterThanValue(){
        PokemonFactory.populate(managedObjectContext);
        PokemonFactory.createType(managedObjectContext, id: .fire, name: .Fire)
        var predicate = Predicate.predicateBuilder("level", value: 16, predicateOperator: .GreaterThan)
        var expectedPredicate = Predicate(format: "level > 16")
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        var count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(3, count, "Count mismatch")
        
        predicate = Predicate.predicateBuilder("level", value: 16, predicateOperator: .GreaterThanOrEqual)
        expectedPredicate = Predicate(format: "level >= 16")
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(6, count, "Count mismatch")
    }
    
    func testPredicateLessThanValue(){
        PokemonFactory.populate(managedObjectContext);
        PokemonFactory.createType(managedObjectContext, id: .fire, name: .Fire)
        
        var predicate = Predicate.predicateBuilder("level", value: 16, predicateOperator: .LessThan)
        var expectedPredicate = Predicate(format: "level < 16")
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        var count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(3, count, "Count mismatch")
        
        predicate = Predicate.predicateBuilder("level", value: 16, predicateOperator: .LessThanOrEqual)
        expectedPredicate = Predicate(format: "level <= 16")
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(6, count, "Count mismatch")
    }
    
    
    func testPredicateContains(){
        PokemonFactory.populate(managedObjectContext);
        let predicate = Predicate.predicateBuilder("name", value: "char", predicateOperator: .Contains)
        let expectedPredicate = Predicate(format: "name contains[c] \"char\"")
        checkPredicate(expectedPredicate, resultPredicate: predicate)
        let count = Pokemon.count(managedObjectContext, predicate: predicate, error: nil)
        XCTAssertEqual(3, count, "Count mismatch")
    }

    
    private func checkPredicate(_ expectedPredicate : Predicate?, resultPredicate: Predicate?){
        XCTAssertNotNil(expectedPredicate, "Shouldn't be nil")
        XCTAssertNotNil(resultPredicate, "Shouldn't be nil")
        XCTAssertEqual(expectedPredicate!, resultPredicate!, "Predicates mismatch")
    }
    


}
