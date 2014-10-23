//
//  SampleDataTableViewController.swift
//  SuperRecordDemo
//
//  Created by Michael Armstrong on 23/10/2014.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import UIKit
import CoreData

class SampleDataTableViewController: UITableViewController {

    
    lazy var fetchedResultsController: NSFetchedResultsController = self.superFetchedResultsController()

    func superFetchedResultsController() -> NSFetchedResultsController {
        return NSFetchedResultsController.superFetchedResultsController("Pokemon", tableView: tableView)
    }
    
    // MARK: - Table view data source


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = self.fetchedResultsController.sections? {
            return sections.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfObjects = self.fetchedResultsController.sections?[section].numberOfObjects {
            return numberOfObjects
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("superCell", forIndexPath: indexPath) as UITableViewCell

        if let pokemon = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Pokemon {
            cell.textLabel.text = "\(pokemon.name) - HP: \(pokemon.hitpoints)"
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
