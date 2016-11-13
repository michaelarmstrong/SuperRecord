//
//  SuperFetchedResultsControllerDelegate.swift
//
//  SuperRecord - A small set of utilities to make working with CoreData a bit easier.
//  http://mike.kz/
//
//  Created by Michael Armstrong on 12/10/2014.
//  Copyright (c) 2014 SuperArmstrong.UK. All rights reserved.
//
//  RESPONSIBILITY : Manage safe batched updates to UITableView and UICollectionView
//
//  Credits: 
//  Largely Inspired by https://github.com/AshFurrow/UICollectionView-NSFetchedResultsController/blob/master/AFMasterViewController.m
//

import Foundation
import UIKit
import CoreData

@objc(SuperFetchedResultsControllerDelegate)
class SuperFetchedResultsControllerDelegate : NSObject, NSFetchedResultsControllerDelegate {
    
    enum ReusableViewType : Int {
        case collectionView
        case tableView
        case unknown
    }
    
    var tableView : UITableView?
    var collectionView : UICollectionView?
    
    var objectChanges : Array<Dictionary<NSFetchedResultsChangeType,IndexPath>> = Array()
    var sectionChanges : Array<Dictionary<NSFetchedResultsChangeType,Int>> = Array()
    
    let kOwnerKey: String = "kOwnerKey"
    weak var owner : AnyObject?
    
    convenience init(tableView tv: UITableView!) {
        
        self.init()

        weak var weakTableView = tv
        let reusableView: UITableView! = weakTableView
        self.tableView = reusableView
    }
    
    convenience init(collectionView cv: UICollectionView!) {
        
        self.init()
        
        weak var weakCollectionView = cv
        let reusableView: UICollectionView! = weakCollectionView
        self.collectionView = reusableView
    }
    
    
    var reusableView : AnyObject? {
        get {
            return self.reusableView
        }
        set {
            // Implement the setter here.
            if (newValue is UICollectionView){
                collectionView = newValue as? UICollectionView
            }
            if (newValue is UITableView){
                tableView = newValue as? UITableView
            }
            self.reusableView = newValue
        }
    }
    
    func receiverType() -> ReusableViewType
    {
        if let _ = collectionView {
            return ReusableViewType.collectionView
        }
        
        if let _ = tableView {
            return ReusableViewType.tableView
        }
        
        return ReusableViewType.unknown
    }
    
    func bindsLifetimeTo(_ owner: AnyObject!) -> Void {
        let oldOwner: AnyObject? = self.owner
        self.owner = owner
        
        var ownerArray : AnyObject? = objc_getAssociatedObject(self.owner, kOwnerKey) as AnyObject?;
        if(ownerArray == nil){
            ownerArray = NSMutableArray()
            objc_setAssociatedObject(self.owner, kOwnerKey, ownerArray, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            //objc_setAssociatedObject(self.owner, kOwnerKey, ownerArray, UInt(objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN));
        }
        ownerArray?.add(self)
        
        if(oldOwner != nil){
            let oldOwnerArray : NSMutableArray = objc_getAssociatedObject(oldOwner, kOwnerKey) as! NSMutableArray;
            oldOwnerArray.removeObject(identicalTo: self)
        }
    }
    
    // !MARK : Reusable View Updates (UICollectionView / UITableView)
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        if(receiverType() == ReusableViewType.tableView){
            tableView!.beginUpdates()
        } else if(receiverType() == ReusableViewType.collectionView) {
            // nothing to do... yet.
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType)
    {
        if(receiverType() == .tableView){
            if type == NSFetchedResultsChangeType.insert {
                tableView!.insertSections(IndexSet(integer: sectionIndex), with: UITableViewRowAnimation.fade)
            }
            else if type == NSFetchedResultsChangeType.delete {
                tableView!.deleteSections(IndexSet(integer: sectionIndex), with: UITableViewRowAnimation.fade)
            }
        } else if(receiverType() == .collectionView) {
            var changeDictionary : Dictionary<NSFetchedResultsChangeType,Int> = Dictionary()
            
            switch (type) {
            case NSFetchedResultsChangeType.insert:
                changeDictionary[type] = sectionIndex
            case NSFetchedResultsChangeType.delete:
                changeDictionary[type] = sectionIndex
            default:
                print("Unexpected NSFetchedResultsChangeType received for didChangeSection. \(type)")
            }
            sectionChanges.append(changeDictionary)
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if(receiverType() == ReusableViewType.tableView){
            switch type {
            case NSFetchedResultsChangeType.insert:
                tableView!.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.fade)
            case NSFetchedResultsChangeType.delete:
                tableView!.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
            case NSFetchedResultsChangeType.update:
                tableView!.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
            case NSFetchedResultsChangeType.move:
                tableView!.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
                tableView!.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.fade)
            }

        } else if(receiverType() == ReusableViewType.collectionView) {
            var changeDictionary = Dictionary<NSFetchedResultsChangeType,IndexPath>()

            switch (type) {
            case NSFetchedResultsChangeType.insert:
                changeDictionary[type] = newIndexPath as IndexPath?
                break
            case NSFetchedResultsChangeType.delete:
                changeDictionary[type] = indexPath as IndexPath?
                break
            case NSFetchedResultsChangeType.update:
                changeDictionary[type] = indexPath as IndexPath?
                break
            case NSFetchedResultsChangeType.move:
                // !TODO : we may need to migrate this to a homogenous Array as I expect this to throw a runtime exception.
                
                //changeDictionary[type] = [indexPath, newIndexPath]
                
                break
            }
            objectChanges.append(changeDictionary)
        }

    }


    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        if(receiverType() == ReusableViewType.tableView){
            tableView!.endUpdates()
        } else if(receiverType() == ReusableViewType.collectionView){
           if(sectionChanges.count > 0){
                collectionView!.performBatchUpdates({() -> Void in
                    for change in self.sectionChanges {
                        for (dictKey,dictValue) in change {
                            switch (dictKey) {
                            case NSFetchedResultsChangeType.insert:
                                self.collectionView!.insertSections(IndexSet(integer: dictValue))
                                break;
                            case NSFetchedResultsChangeType.delete:
                                self.collectionView!.deleteSections(IndexSet(integer: dictValue))
                                break;
                            case NSFetchedResultsChangeType.update:
                                self.collectionView!.reloadSections(IndexSet(integer: dictValue))
                                break;
                            default:
                                print("Unexpected NSFetchedResultsChangeType stored for controllerDidChangeContent. \(dictKey)")
                            }
                        }
                    }
                     }, completion: nil)
            }
        
            
            if(objectChanges.count > 0 && sectionChanges.count == 0){
                
                if(collectionView!.window == nil){
                    collectionView!.reloadData()
                } else {
                    collectionView!.performBatchUpdates({() -> Void in
                        for change in self.objectChanges {
                            for (dictKey,dictValue) in change  {
                                switch (dictKey) {
                                case NSFetchedResultsChangeType.insert:
                                    self.collectionView!.insertItems(at: [dictValue])
                                    break
                                case NSFetchedResultsChangeType.delete:
                                    self.collectionView!.deleteItems(at: [dictValue])
                                    break
                                case NSFetchedResultsChangeType.update:
                                    self.collectionView!.reloadItems(at: [dictValue])
                                    break
                                case NSFetchedResultsChangeType.move:
                                    //TODO: Implement Move properly.
                                    self.collectionView?.reloadData()
                                    break
                                }
                            }
                        }
                    }, completion: nil)
                }
            }
        }
        sectionChanges.removeAll(keepingCapacity: false)
        objectChanges.removeAll(keepingCapacity: false)
    }
}
