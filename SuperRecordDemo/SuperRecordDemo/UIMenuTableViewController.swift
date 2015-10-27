//
//  UIMenuTableViewController.swift
//  SuperRecordDemo
//
//  Created by Piergiuseppe Longo on 26/10/15.
//  Copyright © 2015 SuperRecord. All rights reserved.
//

import UIKit

class UIMenuTableViewController: UITableViewController {

    let menuVoices = [
        "Find All",
        "Find all pokemon sort by Name",
        "Find all pokemon with name containing 'charm'",
        "Find all pokemon of type 'Water'",
        "CollectionView all pokemon",
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuVoices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("PokemonCell")
        if (nil == cell){
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "PokemonCell")
        }
        cell?.textLabel?.text = menuVoices[indexPath.row]
        cell?.textLabel?.numberOfLines = 0
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var viewController: UIViewController!
        
        switch (indexPath.row){
        case  0:
            viewController = PokedexTableViewController()
            break
        case  1:
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            viewController = PokedexTableViewController(sortDescriptors: [sortDescriptor])
            break
        case  2:
            let predicate = NSPredicate.predicateBuilder("name", value: "Charm", predicateOperator: .Contains)!
            viewController = PokedexTableViewController(predicate: predicate)
            break
        case  3:
            let fireType = Type.findFirstOrCreateWithAttribute("name", value: "Water")
            let predicate = NSPredicate.predicateBuilder("types", value: fireType, predicateOperator: .Contains)!
            viewController = PokedexTableViewController(predicate: predicate)
            break
            
        case  4:
            viewController = PokemonCollectionViewController()
            break

        default:
            print("Not implemented method");
            abort()
            
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
