//
//  PokemonCollectionViewController.swift
//  SuperRecordDemo
//
//  Created by Piergiuseppe Longo on 27/10/15.
//  Copyright © 2015 SuperRecord. All rights reserved.
//

import UIKit
import CoreData

import SuperRecord


private let reuseIdentifier = "PokemonCollectionViewCell"

class PokemonCollectionViewController: UICollectionViewController {
    

    
    init(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: PokemonCollectionViewCell.cellWidth, height: PokemonCollectionViewCell.cellHeight)
        super.init(collectionViewLayout: layout)
        self.collectionView!.registerClass(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    lazy var fetchedResultsController: NSFetchedResultsController = self.superFetchedResultsController()

    func superFetchedResultsController() -> NSFetchedResultsController {
        return NSFetchedResultsController.superFetchedResultsController("Pokemon", collectionView: self.collectionView)
        
    }
    
    override func viewDidLoad() {

        self.collectionView?.backgroundColor  = UIColor.whiteColor()
        super.viewDidLoad()

        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PokemonCollectionViewCell
        let pokemon = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Pokemon
        cell.backgroundColor = UIColor.whiteColor()
        cell.nameLabel.text = pokemon.name
        cell.image.image = UIImage(named: "\(pokemon.national_id)")
        return cell
    }

}
