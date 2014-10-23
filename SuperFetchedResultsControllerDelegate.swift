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
        case CollectionView
        case TableView
        case Unknown
    }
    
    var tableView : UITableView?
    var collectionView : UICollectionView?
    
    var objectChanges : Array<Dictionary<NSFetchedResultsChangeType,AnyObject>> = Array()
    var sectionChanges : Array<Dictionary<NSFetchedResultsChangeType,Int>> = Array()
    
    let kOwnerKey: String = "kOwnerKey"
    weak var owner : AnyObject?
    
    
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
        if let reusableView = collectionView {
            return ReusableViewType.CollectionView
        }
        
        if let reusableView = tableView {
            return ReusableViewType.TableView
        }
        
        return ReusableViewType.Unknown
    }
    
    func bindsLifetimeTo(owner: AnyObject!) -> Void {
        var oldOwner: AnyObject? = self.owner
        self.owner = owner
        
        var ownerArray : AnyObject? = objc_getAssociatedObject(self.owner, kOwnerKey);
        if(ownerArray == nil){
            ownerArray = NSMutableArray()
            objc_setAssociatedObject(self.owner, kOwnerKey, ownerArray, UInt(OBJC_ASSOCIATION_RETAIN));
        }
        ownerArray?.addObject(self)
        
        if(oldOwner != nil){
            var oldOwnerArray : NSMutableArray = objc_getAssociatedObject(oldOwner, kOwnerKey) as NSMutableArray;
            oldOwnerArray.removeObjectIdenticalTo(self)
        }
    }
    
    // !MARK : Reusable View Updates (UICollectionView / UITableView)
    
    func controllerWillChangeContent(controller: NSFetchedResultsController!)
    {
        if(receiverType() == ReusableViewType.TableView){
            tableView!.beginUpdates()
        } else if(receiverType() == ReusableViewType.CollectionView) {
            // nothing to do... yet.
        }
    }
    
    func controller(controller: NSFetchedResultsController!, didChangeSection sectionInfo: NSFetchedResultsSectionInfo!, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType)
    {
        if(receiverType() == .TableView){
            if type == NSFetchedResultsChangeType.Insert {
                tableView!.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            }
            else if type == NSFetchedResultsChangeType.Delete {
                tableView!.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            }
        } else if(receiverType() == .CollectionView) {
            var changeDictionary : Dictionary<NSFetchedResultsChangeType,Int> = Dictionary()
            
            switch (type) {
            case NSFetchedResultsChangeType.Insert:
                changeDictionary[type] = sectionIndex
            case NSFetchedResultsChangeType.Delete:
                changeDictionary[type] = sectionIndex
            default:
                println("Unexpected NSFetchedResultsChangeType received for didChangeSection. \(type)")
            }
            sectionChanges.append(changeDictionary)
        }
    }

    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!)
    {
        if(receiverType() == ReusableViewType.TableView){
            switch type {
            case NSFetchedResultsChangeType.Insert:
                tableView!.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            case NSFetchedResultsChangeType.Delete:
                tableView!.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            case NSFetchedResultsChangeType.Update:
                tableView!.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            case NSFetchedResultsChangeType.Move:
                tableView!.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                tableView!.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            default:
                println("Unexpected NSFetchedResultsChangeType received for didChangeObject. \(type)")
            }
        } else if(receiverType() == ReusableViewType.CollectionView) {
            var changeDictionary : Dictionary<NSFetchedResultsChangeType,AnyObject> = Dictionary()
            
            switch (type) {
            case NSFetchedResultsChangeType.Insert:
                changeDictionary[type] = newIndexPath
                break;
            case NSFetchedResultsChangeType.Delete:
                changeDictionary[type] = indexPath
                break;
            case NSFetchedResultsChangeType.Update:
                changeDictionary[type] = indexPath
                break;
            case NSFetchedResultsChangeType.Move:
                // !TODO : we may need to migrate this to a homogenous Array as I expect this to throw a runtime exception.
                changeDictionary[type] = [indexPath, newIndexPath]
                break;
            default:
                println("Unexpected NSFetchedResultsChangeType received for didChangeObject. \(type)")
            }
            objectChanges.append(changeDictionary)
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController!)
    {
        if(receiverType() == ReusableViewType.TableView){
            tableView!.endUpdates()
        } else if(receiverType() == ReusableViewType.CollectionView){
           if(sectionChanges.count > 0){
                collectionView!.performBatchUpdates({() -> Void in
                    for change in self.sectionChanges {
                        for (dictKey,dictValue) in change {
                            switch (dictKey) {
                            case NSFetchedResultsChangeType.Insert:
                                self.collectionView!.insertSections(NSIndexSet(index: dictValue))
                                break;
                            case NSFetchedResultsChangeType.Delete:
                                self.collectionView!.deleteSections(NSIndexSet(index: dictValue))
                                break;
                            case NSFetchedResultsChangeType.Update:
                                self.collectionView!.reloadSections(NSIndexSet(index: dictValue))
                                break;
                            default:
                                println("Unexpected NSFetchedResultsChangeType stored for controllerDidChangeContent. \(dictKey)")
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
                            for (dictKey,dictValue) in change {
                                switch (dictKey) {
                                case NSFetchedResultsChangeType.Insert:
                                    self.collectionView!.insertItemsAtIndexPaths([dictValue])
                                    break;
                                case NSFetchedResultsChangeType.Delete:
                                    self.collectionView!.deleteItemsAtIndexPaths([dictValue])
                                    break;
                                case NSFetchedResultsChangeType.Update:
                                    self.collectionView!.reloadItemsAtIndexPaths([dictValue])
                                    break;
                                case NSFetchedResultsChangeType.Move:
                                    self.collectionView!.moveItemAtIndexPath(dictValue[0] as NSIndexPath, toIndexPath: dictValue[1] as NSIndexPath)
                                    break;
                                default:
                                println("Unexpected NSFetchedResultsChangeType stored for controllerDidChangeContent. \(dictKey)")
                                }
                            }
                        }
                    }, completion: nil)
                }
            }
        }
        sectionChanges.removeAll(keepCapacity: false)
        objectChanges.removeAll(keepCapacity: false)
    }
}