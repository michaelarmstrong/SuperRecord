//
//  Pokemon.swift
//  SuperRecord
//
//  Created by Piergiuseppe Longo on 18/11/14.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import Foundation
import CoreData

@objc(Pokemon)
class Pokemon: NSManagedObject {

    @NSManaged var level: NSNumber
    @NSManaged var name: String
    @NSManaged var type: Type

}
