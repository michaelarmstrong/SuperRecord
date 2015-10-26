//
//  AppDelegate.swift
//  SuperRecordDemo
//
//  Created by Piergiuseppe Longo on 23/10/15.
//  Copyright © 2015 SuperRecord. All rights reserved.
//

import UIKit
import CoreData
import SuperRecord
import Alamofire
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func downloadTypes(){
        for typeNumber in 1...20{
            Alamofire.request(.GET, "http://pokeapi.co/api/v1/type/\(typeNumber)")
                .responseJSON { response in
                    if let JSON = response.result.value {
                        let type = Type.createNewEntity() as! Type
                        type.name = JSON["name"] as! String
                        let id =  JSON["id"] as! Int
                        type.typeID = Int16(id)
                        try! SuperCoreDataStack.defaultStack.managedObjectContext!.save()
                    }
            }
        }
    }
    
    func downloadPokemon () {
        for pokemonNumber in 1...10{
            Alamofire.request(.GET, "http://pokeapi.co/api/v1/pokemon/\(pokemonNumber)")
                .responseJSON { response in
                    if let JSON = response.result.value {
                        
                        let pokemon  = Pokemon.createNewEntity() as! Pokemon
                        pokemon.name = JSON["name"] as! String
                        let id =  JSON["national_id"] as! Int
                        pokemon.national_id = Int16(id)
                        for pokemonType in JSON["types"] as! [AnyObject] {
                            let typeName = (pokemonType["name"] as! String).capitalizedString
                            print(typeName);
                            let type = Type.findFirstOrCreateWithAttribute("name", value: typeName) as! Type
                            pokemon.types.insert(type)
                        }
                        try! SuperCoreDataStack.defaultStack.managedObjectContext!.save()
                    }
            }

        }
        
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let rootViewController = UINavigationController(rootViewController: UIMenuTableViewController());
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = rootViewController
        self.window!.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
}

