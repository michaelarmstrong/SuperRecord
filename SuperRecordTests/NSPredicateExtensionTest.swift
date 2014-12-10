//
//  NSPredicateExtensionTest.swift
//  SuperRecord
//
//  Created by Piergiuseppe Longo on 04/12/14.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import UIKit
import XCTest

class NSPredicateExtensionTest: XCTestCase {

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
    
    private func checkPreficate(expectedPredicate : NSPredicate?, resultPredicate: NSPredicate?){
        XCTAssertNotNil(expectedPredicate, "Shouldn't be nil")
        XCTAssertNotNil(resultPredicate, "Shouldn't be nil")
        XCTAssertEqual(expectedPredicate!, resultPredicate!, "Predicates mismatch")

    }

}
