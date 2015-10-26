//
//  Pokemon+CoreDataProperties.swift
//  SuperRecordDemo
//
//  Created by Piergiuseppe Longo on 23/10/15.
//  Copyright © 2015 SuperRecord. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pokemon {

    @NSManaged var name: String
    @NSManaged var national_id: Int16
    @NSManaged var types: Set<Type>


}
