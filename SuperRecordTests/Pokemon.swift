//
//  Pokemon.swift
//  SuperRecord
//
//  Created by Piergiuseppe Longo on 21/11/14.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import Foundation
import CoreData

class Pokemon: NSManagedObject {

    @NSManaged var level: NSNumber
    @NSManaged var name: String
    @NSManaged var id: NSNumber
    @NSManaged var type: Type

}
