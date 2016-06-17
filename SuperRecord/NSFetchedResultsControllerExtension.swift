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

func superFetchedResultsController(_ entityName: String!, collectionView: UICollectionView!, context: NSManagedObjectContext? = SuperCoreDataStack.defaultStack.managedObjectContext) -> NSFetchedResultsController<NSFetchRequestResult> {
    //        let fetchedResultsDelegate = setupFetchedResultsControllerDelegate(collectionView)
    //        let fetchedResultsController =  superFetchedResultsController(entityName, sectionNameKeyPath: nil, sortDescriptors: nil, predicate: nil, delegate: fetchedResultsDelegate, context: context)
    //        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
    fatalError()
    //        return fetchedResultsController
}

public extension NSFetchedResultsController {
    
    // MARK: Public Methods
    


    class func superFetchedResultsController(_ entityName: String!, tableView: UITableView!, context: NSManagedObjectContext? = SuperCoreDataStack.defaultStack.managedObjectContext) -> NSFetchedResultsController {
        let fetchedResultsDelegate = setupFetchedResultsControllerDelegate(tableView)
        let fetchedResultsController =  superFetchedResultsController(entityName, sectionNameKeyPath: nil, sortDescriptors: nil, predicate: nil, delegate: fetchedResultsDelegate, context: context)
        
        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
        return fetchedResultsController
    }
    
    class func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortedBy: String?, ascending: Bool, collectionView: UICollectionView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortedBy: sortedBy, ascending: ascending, delegate: delegate)
    }
    
    class func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [SortDescriptor]?, predicate: Predicate?, collectionView: UICollectionView!, delegate: NSFetchedResultsControllerDelegate, context: NSManagedObjectContext!) -> NSFetchedResultsController {
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: delegate, context: context)
    }
    
    class func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [SortDescriptor]?, predicate: Predicate?, tableView: UITableView!, delegate: NSFetchedResultsControllerDelegate, context: NSManagedObjectContext!) -> NSFetchedResultsController {
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: delegate,  context: context)
    }
    
    class func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [SortDescriptor]?, predicate: Predicate?, collectionView: UICollectionView!, context: NSManagedObjectContext!) -> NSFetchedResultsController {
        let fetchedResultsDelegate = setupFetchedResultsControllerDelegate(collectionView)
        let fetchedResultsController = superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: fetchedResultsDelegate, context: context)
        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
        return fetchedResultsController
    }
    
    class func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [SortDescriptor]?, predicate: Predicate?, tableView: UITableView!, context: NSManagedObjectContext!) -> NSFetchedResultsController {
        let fetchedResultsDelegate = setupFetchedResultsControllerDelegate(tableView)
        let fetchedResultsController = superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: fetchedResultsDelegate, context: context)
        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
        return fetchedResultsController
    }
    
    
    // MARK: Private Methods
    
    private class func setupFetchedResultsControllerDelegate(_ tableView: UITableView!) -> SuperFetchedResultsControllerDelegate {
        let fetchedResultsDelegate = SuperFetchedResultsControllerDelegate()
        weak var weakTableView = tableView
        let reusableView: UITableView! = weakTableView
        fetchedResultsDelegate.tableView = reusableView
        return fetchedResultsDelegate
    }
    
    private class func setupFetchedResultsControllerDelegate(_ collectionView: UICollectionView!) -> SuperFetchedResultsControllerDelegate {
        let fetchedResultsDelegate = SuperFetchedResultsControllerDelegate()
        weak var weakCollectionView = collectionView
        let reusableView: UICollectionView! = weakCollectionView
        fetchedResultsDelegate.collectionView = reusableView
        return fetchedResultsDelegate
    }
    
    private class func superFetchedResultsController(_ entityName: String!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        return superFetchedResultsController(entityName, sectionNameKeyPath: nil, sortDescriptors: nil, predicate: nil, delegate: delegate)
    }
    
    private class func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortedBy: String?, ascending: Bool, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        
        var sortDescriptors: [SortDescriptor]? = nil
        if let sortedBy = sortedBy {
            sortDescriptors = [SortDescriptor(key: sortedBy, ascending: ascending)]
        }
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate:nil, delegate: delegate)
    }
    
    private class func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [SortDescriptor]?, predicate: Predicate?, delegate: NSFetchedResultsControllerDelegate, context: NSManagedObjectContext! = SuperCoreDataStack.defaultStack.managedObjectContext!) -> NSFetchedResultsController {
        
        
        //let fetchRequest = NSFetchRequest<"EntityName">(entityName: entityName)
        let fetchRequest = NSFetchRequest<ResultType>(entityName: entityName)
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors
        } else {
            fetchRequest.sortDescriptors = []
        }
        
        var tempFetchedResultsController : NSFetchedResultsController!
        if let sectionNameKeyPath = sectionNameKeyPath {
            tempFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest , managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
        } else {
            tempFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest , managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
        tempFetchedResultsController.delegate = delegate
        
        NSFetchedResultsController.deleteCache(withName: nil)
        
        var error : NSError?
        do {
            try tempFetchedResultsController.performFetch()
        } catch let error1 as NSError {
            error = error1
        } catch {
            //TODO: Populate exhaustive thrown types
        }
        
        if (error != nil){
            //TODO: This needs actual error handling.
            print("Error : \(error)")
        }
        
        return tempFetchedResultsController
    }
    
}
