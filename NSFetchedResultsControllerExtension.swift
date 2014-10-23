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

extension NSFetchedResultsController {
    
    private class func superFetchedResultsController(entityName: NSString!, reusableView: UIScrollView, delegate: SuperFetchedResultsControllerDelegate) -> NSFetchedResultsController {
        
        let context = SuperCoreDataStack.defaultStack.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
        //TODO: Implement ability to specify sort descriptors and section key paths at runtime.
        let sortDescriptors = []
        fetchRequest.sortDescriptors = sortDescriptors
        let tempFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest , managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        NSFetchedResultsController.deleteCacheWithName(nil)
        
        var error : NSError?
        tempFetchedResultsController.performFetch(&error)
        
        if (error != nil){
            //TODO: This needs actual error handling.
            println("Error : \(error)")
        }
        
        delegate.bindsLifetimeTo(tempFetchedResultsController)
    
        return tempFetchedResultsController
    }
    
    class func superFetchedResultsController(entityName: NSString!, collectionView: UICollectionView) -> NSFetchedResultsController {
        let fetchedResultsDelegate = SuperFetchedResultsControllerDelegate()
        weak var weakCollectionView = collectionView
        let reusableView: UICollectionView! = weakCollectionView
        fetchedResultsDelegate.collectionView = reusableView
        return superFetchedResultsController(entityName, reusableView: reusableView, delegate: fetchedResultsDelegate)
    }
    
    class func superFetchedResultsController(entityName: NSString!, tableView: UITableView) -> NSFetchedResultsController {
        let fetchedResultsDelegate = SuperFetchedResultsControllerDelegate()
        weak var weakTableView = tableView
        let reusableView: UITableView! = weakTableView
        fetchedResultsDelegate.tableView = reusableView
        return superFetchedResultsController(entityName, reusableView: reusableView, delegate: fetchedResultsDelegate)
    }
}
