//
//  Pokemon.swift
//  SuperRecordDemo
//
//  Created by Michael Armstrong on 23/10/2014.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import Foundation
import CoreData

//TODO: Add support for Module based Managed Object subclasses (removing need for @objc(className)
@objc(Pokemon)
class Pokemon: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var hitpoints: NSNumber

}
