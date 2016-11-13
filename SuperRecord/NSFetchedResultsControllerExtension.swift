//
//  FetchedResultsControllerExtension.swift
//
//  SuperRecord - A small set of utilities to make working with CoreData a bit easier.
//  http://mike.kz/
//
//  Created by Michael Armstrong on 21/10/2014.
//  Copyright (c) 2014 SuperArmstrong.UK. All rights reserved.
//
//  RESPONSIBILITY : Setup a Fetched Results controller ready for use with the Delegate.

import CoreData
import UIKit

// BROKEN : https://bugs.swift.org/browse/SR-2708
public extension NSFetchedResultsController {
    
    // MARK: Public Methods
    
//    class func superFetchedResultsController(_ entityName: String!, collectionView: UICollectionView!, context: NSManagedObjectContext? = SuperCoreDataStack.defaultStack.managedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult> {
//        
//        let fetchedResultsDelegate = SuperFetchedResultsControllerDelegate(collectionView: collectionView)
//        
//        let fetchedResultsController =  superFetchedResultsController(entityName, sectionNameKeyPath: nil, sortDescriptors: nil, predicate: nil, delegate: fetchedResultsDelegate, context: context)
//        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
//        return fetchedResultsController
//    }
//
//    class func superFetchedResultsController(_ entityName: String!, tableView: UITableView!, context: NSManagedObjectContext? = SuperCoreDataStack.defaultStack.managedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult>  {
//        let fetchedResultsDelegate = SuperFetchedResultsControllerDelegate(tableView: tableView)
//        let fetchedResultsController =  superFetchedResultsController(entityName, sectionNameKeyPath: nil, sortDescriptors: nil, predicate: nil, delegate: fetchedResultsDelegate, context: context)
//        
//        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
//        return fetchedResultsController
//    }
//    
//    class func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortedBy: String?, ascending: Bool, collectionView: UICollectionView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<NSFetchRequestResult>  {
//        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortedBy: sortedBy, ascending: ascending, delegate: delegate)
//    }
//    
//    class func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?, collectionView: UICollectionView!, delegate: NSFetchedResultsControllerDelegate, context: NSManagedObjectContext!) -> NSFetchedResultsController<NSFetchRequestResult>  {
//        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: delegate, context: context)
//    }
//    
//    class func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?, tableView: UITableView!, delegate: NSFetchedResultsControllerDelegate, context: NSManagedObjectContext!) -> NSFetchedResultsController<NSFetchRequestResult>  {
//        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: delegate,  context: context)
//    }
//    
//    class func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?, collectionView: UICollectionView!, context: NSManagedObjectContext!) -> NSFetchedResultsController<NSFetchRequestResult>  {
//        let fetchedResultsDelegate = SuperFetchedResultsControllerDelegate(collectionView: collectionView)
//        let fetchedResultsController = superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: fetchedResultsDelegate, context: context)
//        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
//        return fetchedResultsController
//    }
//    
//    class func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?, tableView: UITableView!, context: NSManagedObjectContext!) -> NSFetchedResultsController<NSFetchRequestResult>  {
//        let fetchedResultsDelegate = SuperFetchedResultsControllerDelegate(tableView: tableView)
//        let fetchedResultsController = superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: fetchedResultsDelegate, context: context)
//        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
//        return fetchedResultsController
//    }
//    
//    
//    // MARK: Private Methods
//    
//    fileprivate class func superFetchedResultsController(_ entityName: String!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<NSFetchRequestResult> {
//        return superFetchedResultsController(entityName, sectionNameKeyPath: nil, sortDescriptors: nil, predicate: nil, delegate: delegate)
//    }
//    
//    fileprivate class func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortedBy: String?, ascending: Bool, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<NSFetchRequestResult> {
//        
//        var sortDescriptors: [NSSortDescriptor]? = nil
//        if let sortedBy = sortedBy {
//            sortDescriptors = [NSSortDescriptor(key: sortedBy, ascending: ascending)]
//        }
//        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate:nil, delegate: delegate)
//    }
//    
//    fileprivate class func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?, delegate: NSFetchedResultsControllerDelegate, context: NSManagedObjectContext! = SuperCoreDataStack.defaultStack.managedObjectContext!) -> NSFetchedResultsController<NSFetchRequestResult> {
//        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
//        
//        if let predicate = predicate {
//            fetchRequest.predicate = predicate
//        }
//        if let sortDescriptors = sortDescriptors {
//            fetchRequest.sortDescriptors = sortDescriptors
//        } else {
//            fetchRequest.sortDescriptors = []
//        }
//        
//        var tempFetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>
//        if let sectionNameKeyPath = sectionNameKeyPath {
//            tempFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
//        } else {
//            tempFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        }
//        tempFetchedResultsController.delegate = delegate
//        
//        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
//        
//        var error : NSError?
//        do {
//            try tempFetchedResultsController.performFetch()
//        } catch let error1 as NSError {
//            error = error1
//        }
//        
//        if (error != nil){
//            //TODO: This needs actual error handling.
//            print("Error : \(error)")
//        }
//        
//        return tempFetchedResultsController
//    }
    
}
