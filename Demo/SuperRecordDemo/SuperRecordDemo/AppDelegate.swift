//
//  AppDelegate.swift
//  SuperRecordDemo
//
//  Created by Michael Armstrong on 23/10/2014.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupSampleData()
        return true
    }
    
    func setupSampleData() {
      
        Pokemon.deleteAll()
        
        let pokemonDict = ["Pikachu" : 42, "Squirtle" : 19, "Charmander" : 34]
        
        for (name,hitpoints) in pokemonDict {
            
            let pokemon = Pokemon.createNewEntity() as Pokemon
            pokemon.name = name
            pokemon.hitpoints = hitpoints
        
        }
        
        SuperCoreDataStack.defaultStack.saveContext()
    }


    func applicationWillTerminate(application: UIApplication) {
        SuperCoreDataStack.defaultStack.saveContext()
    }

}

