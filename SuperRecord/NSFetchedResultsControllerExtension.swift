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

public extension NSFetchedResultsController {
    
    // MARK: Public Methods
    class func superFetchedResultsController(entityName: NSString!, collectionView: UICollectionView!) -> NSFetchedResultsController {
        let fetchedResultsDelegate = setupFetchedResultsControllerDelegate(collectionView)
        let fetchedResultsController = superFetchedResultsController(entityName, reusableView: collectionView, delegate: fetchedResultsDelegate)
        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
        return fetchedResultsController
    }
    
    class func superFetchedResultsController(entityName: NSString!, tableView: UITableView!) -> NSFetchedResultsController {
        let fetchedResultsDelegate = setupFetchedResultsControllerDelegate(tableView)
        let fetchedResultsController =  superFetchedResultsController(entityName, reusableView: tableView, delegate: fetchedResultsDelegate)
        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
        return fetchedResultsController
    }
    
    class func superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortedBy: NSString?, ascending: Bool, tableView: UITableView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortedBy: sortedBy, ascending: ascending, delegate: delegate)
    }
    
    class func superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortedBy: NSString?, ascending: Bool, collectionView: UICollectionView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortedBy: sortedBy, ascending: ascending, delegate: delegate)
    }
    
    class func superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortDescriptors: NSArray?, predicate: NSPredicate?, collectionView: UICollectionView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: delegate)
    }
    
    class func superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortDescriptors: NSArray?, predicate: NSPredicate?, tableView: UITableView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: delegate)
    }
    
    class func superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortDescriptors: NSArray?, predicate: NSPredicate?, collectionView: UICollectionView!, delegate: NSFetchedResultsControllerDelegate, context: NSManagedObjectContext!) -> NSFetchedResultsController {
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: delegate, context: context)
    }
    
    class func superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortDescriptors: NSArray?, predicate: NSPredicate?, tableView: UITableView!, delegate: NSFetchedResultsControllerDelegate, context: NSManagedObjectContext!) -> NSFetchedResultsController {
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: delegate,  context: context)
    }
    
    class func superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortDescriptors: NSArray?, predicate: NSPredicate?, collectionView: UICollectionView!, context: NSManagedObjectContext!) -> NSFetchedResultsController {
        let fetchedResultsDelegate = setupFetchedResultsControllerDelegate(collectionView)
        let fetchedResultsController = superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: fetchedResultsDelegate, context: context)
        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
        return fetchedResultsController
    }
    
    class func superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortDescriptors: NSArray?, predicate: NSPredicate?, tableView: UITableView!, context: NSManagedObjectContext!) -> NSFetchedResultsController {
        let fetchedResultsDelegate = setupFetchedResultsControllerDelegate(tableView)
        let fetchedResultsController = superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: fetchedResultsDelegate, context: context)
        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
        return fetchedResultsController
    }
    
    
    // MARK: Private Methods
    
    private class func setupFetchedResultsControllerDelegate(tableView: UITableView!) -> SuperFetchedResultsControllerDelegate {
        let fetchedResultsDelegate = SuperFetchedResultsControllerDelegate()
        weak var weakTableView = tableView
        let reusableView: UITableView! = weakTableView
        fetchedResultsDelegate.tableView = reusableView
        return fetchedResultsDelegate
    }
    
    private class func setupFetchedResultsControllerDelegate(collectionView: UICollectionView!) -> SuperFetchedResultsControllerDelegate {
        let fetchedResultsDelegate = SuperFetchedResultsControllerDelegate()
        weak var weakCollectionView = collectionView
        let reusableView: UICollectionView! = weakCollectionView
        fetchedResultsDelegate.collectionView = reusableView
        return fetchedResultsDelegate
    }
    
    private class func superFetchedResultsController(entityName: NSString!, reusableView: UIScrollView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        return superFetchedResultsController(entityName, sectionNameKeyPath: nil, sortDescriptors: nil, predicate: nil, delegate: delegate)
    }
    
    private class func superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortedBy: NSString?, ascending: Bool, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        
        var sortDescriptors = []
        if let sortedBy = sortedBy {
            sortDescriptors = [NSSortDescriptor(key: sortedBy, ascending: ascending)]
        }
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate:nil, delegate: delegate)
    }
    
    private class func superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortDescriptors: NSArray?, predicate: NSPredicate?, delegate: NSFetchedResultsControllerDelegate, context: NSManagedObjectContext!) -> NSFetchedResultsController {
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors
        } else {
            fetchRequest.sortDescriptors = []
        }
        fetchRequest.sortDescriptors = sortDescriptors
        
        var tempFetchedResultsController : NSFetchedResultsController!
        if let sectionNameKeyPath = sectionNameKeyPath {
            tempFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest , managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
        } else {
            tempFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest , managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
        NSFetchedResultsController.deleteCacheWithName(nil)
        
        var error : NSError?
        tempFetchedResultsController.performFetch(&error)
        
        if (error != nil){
            //TODO: This needs actual error handling.
            println("Error : \(error)")
        }
        
        return tempFetchedResultsController
    }
    
    private class func superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortDescriptors: NSArray?, predicate: NSPredicate? , delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        let context = SuperCoreDataStack.defaultStack.managedObjectContext!
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: delegate, context: context)
    }
}
