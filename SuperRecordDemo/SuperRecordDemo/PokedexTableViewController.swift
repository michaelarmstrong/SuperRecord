//
//  PokedexTableViewController.swift
//  SuperRecordDemo
//
//  Created by Piergiuseppe Longo on 23/10/15.
//  Copyright © 2015 SuperRecord. All rights reserved.
//

import UIKit
import CoreData
import SuperRecord
import Alamofire

class PokedexTableViewController: UITableViewController {
    
    var sortDescriptors: [NSSortDescriptor]?
    var predicate: NSPredicate?
    
    init(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] =  [NSSortDescriptor(key: "national_id", ascending: true)] ){
        super.init(style: UITableViewStyle.Plain)
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    lazy var fetchedResultsController: NSFetchedResultsController = self.superFetchedResultsController()
    func superFetchedResultsController() -> NSFetchedResultsController {
        
        return NSFetchedResultsController.superFetchedResultsController("Pokemon", sectionNameKeyPath: nil, sortDescriptors: sortDescriptors, predicate: predicate, tableView: tableView, context: SuperCoreDataStack.defaultStack.managedObjectContext)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("PokemonCell")
        if (nil == cell){
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "PokemonCell")
        }
        self.configureCell(cell!, atIndexPath: indexPath)
        return cell!
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
            
            do {
                try context.save()
            } catch {
                abort()
            }
        }
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let pokemon = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Pokemon
        cell.detailTextLabel!.text = pokemon.name
        cell.textLabel!.text = "\(pokemon.national_id)"
    }

}
