SuperRecord  
===================


[![Build Status](https://travis-ci.org/michaelarmstrong/SuperRecord.svg)](https://travis-ci.org/michaelarmstrong/SuperRecord/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![CocoaPods](https://img.shields.io/cocoapods/v/SuperRecord.svg)


===================

** SUPPORTS SWIFT 2.0 from Version >= 1.4 **
** SUPPORTS SWIFT 1.2 from Version <= 1.3 **
 
A **Swift CoreData Framework** consisting of several **Extensions** and Helpers to bring some love and take the hassle out of common CoreData tasks.

----------
Each piece of functionality can be used independently and discreetly, so there is no need for a "buy in" to the whole project. For example, you could use your own `NSFetchedResultsController` or `NSManagedObjectContext` with any of the finders or even the `SuperFetchedResultsControllerDelegate`

I'd like to make a big shout-out to MagicalRecord, which I think lay great foundations for these kind of projects. Although its had its ups and downs, it seems under heavy development. This Swift SuperRecord project was obviously heavily inspired by work done in MagicalRecord.

Features
-------------

SuperRecord consists of several Extensions to add MagicalRecord/ActiveRecord style "finders" to your NSManagedObject subclasses, a **FetchResultsControllerDelegate** class to handle safe batch updates to both **UITableView** and **UICollectionView** and an experimental Boilerplate CoreData Stack Singleton.  

The project has been built over several versions of Swift so some choices may seem strange at first. 

### Adding SuperRecord to your project

#### Method 1 (Cocoapods)

To integrate SuperRecord into your Xcode project using [Cocoapods](http://cocoapods.org/), specify it in your Podfile:

	use_frameworks!
	pod 'SuperRecord'
	
- Build	
- Add import SuperRecord

#### Method 2 (Carthage)

To integrate SuperRecord into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your Cartfile:

	github "michaelarmstrong/SuperRecord"
	
	
#### Method 3 (Submodule)

	git submodule add https://github.com/michaelarmstrong/SuperRecord.git SuperRecord

- Drag the checked out submodule into Xcode
- Click on your main application target
- Open "Build Phases"
- Add SuperRecord.framework under "Target Dependencies"

#### Method 4 (Manually)

	git clone https://github.com/michaelarmstrong/SuperRecord.git
	
Now add the source files into your project directly.


## Core Files
> - **NSManagedObjectExtension.swift** 
>      This extension is responsible for most of the "finder" functionality and has operations such as `deleteAll()`, `findOrCreateWithAttribute()` `createEntity()` and allows you to specify your own `NSManagedObjectContext` or use the default one (running on the main thread).
>      
> - **NSFetchedResultsControllerExtension.swift**
> In constant development, this Extension allows the easy creation of `FetchedResultsControllers` for use with `UICollectionView` and `UITableView` that utilise the `SuperFetchedResultsControllerDelegate` for safe batch updates.
>
> - **SuperFetchedResultsControllerDelegate.swift** heavily inspired by past-projects i've worked on along with other popular open source projects. This handles **safe batch updates** to `UICollectionView` and `UITableView` across iOS 7 and iOS 8. It can be used on its own with your `NSFetchedResultsController` or alternatively, its automatically used by the `NSFetchedResultsControllerExtension` methods included in **SuperRecord**.
>
> - **SuperCoreDataStack.swift** a boilerplate experimental main thread CoreData stack. Can be used either as a sqlite store or in memory store. Simply by calling `SuperCoreDataStack.defaultStack()` for SQLite or `SuperCoreDataStack.inMemoryStack()` for an in memory store. Of course you have access to your context `.context` / `.saveContext()`

## Usage

#### <i class="icon-file"></i> Create a new Entity
Assuming you have an NSManagedObject of type "Pokemon" you could do the following

	let pokemon = Pokemon.createNewEntity() as Pokemon

Please add `@objc(className)` above the class name of all your `NSManagedObject` subclasses (as shown in the demo project) for now. Better support will be coming in the future.

#### <i class="icon-folder-open"></i> Creating an NSFetchedResultsController
There are many factory methods for your convenience that **SuperRecord** adds to `NSFetchedResultsController` to make your life simpler, yet still powerful. As always, you don't have to use these with SuperRecord, however they are there for your convenience. Many of the SuperRecord factory methods will handle safe batch updates for you to your passed collectionView or tableView. No more song and dance.

	lazy var fetchedResultsController: NSFetchedResultsController = self.superFetchedResultsController()
	
	func superFetchedResultsController() -> NSFetchedResultsController {
	return NSFetchedResultsController.superFetchedResultsController("Pokemon", tableView: tableView)
	}

Or for some more advanced usage (collectionView with multiple sections and a predicate with automatic batch updates):

    let sortDescriptors = [NSSortDescriptor(key: "evolutionLevel", ascending: false),NSSortDescriptor(key: "level", ascending: false)]
    let predicate = NSPredicate(format: "trainer = %@", self.trainer)!
    let tempFetchedResultsController = NSFetchedResultsController.superFetchedResultsController("Pokemon", sectionNameKeyPath: "evolutionLevel", sortDescriptors: sortDescriptors, predicate: predicate, collectionView: self.collectionView, context: context)	


With `Pokemon` being the entity name of your `NSManagedObject`.


#### <i class="icon-trash"></i> Delete Entities

I'm planning on adding much more powerful functionality around Delete soon, such as deleteAllWithPredicate() or deleteEntity(), right now all that is available is

	Pokemon.deleteAll()


### Method Listing
This isn't an exhaustive list of all methods and classes, however it includes some of the most useful ones.

#### NSManagedObjectExtension
- `findAllWithPredicate(predicate: NSPredicate!, context: NSManagedObjectContext) -> NSArray`
- `findAllWithPredicate(predicate: NSPredicate!) -> NSArray`
- `deleteAll(context: NSManagedObjectContext) -> Void`
- `deleteAll() -> Void`
- `findAll(context: NSManagedObjectContext) -> NSArray`
- `findAll() -> NSArray`
- `findFirstOrCreateWithPredicate(predicate: NSPredicate!) -> NSManagedObject`
- `findFirstOrCreateWithPredicate(predicate: NSPredicate!, context: NSManagedObjectContext) -> NSManagedObject`
- `createNewEntity() -> NSManagedObject`
- `findFirstOrCreateWithAttribute(attribute: NSString!, value: NSString!, context: NSManagedObjectContext) -> NSManagedObject`
- `findFirstOrCreateWithAttribute(attribute: NSString!, value: NSString!) -> NSManagedObject`


#### NSFetchedResultsControllerExtension

**`NSFetchedResultsControllers` created using the below methods will automatically handle safe batch updates to the passed `UITableView` or `UICollectionView`**

- `superFetchedResultsController(entityName: NSString!, collectionView: UICollectionView) -> NSFetchedResultsController`
- `superFetchedResultsController(entityName: NSString!, tableView: UITableView) -> NSFetchedResultsController`
- `superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortDescriptors: NSArray?, predicate: NSPredicate?, collectionView: UICollectionView!, context: NSManagedObjectContext!) -> NSFetchedResultsController`
- `superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortDescriptors: NSArray?, predicate: NSPredicate?, tableView: UITableView!, context: NSManagedObjectContext!) -> NSFetchedResultsController`

**`NSFetchedResultsControllers` created using the below methods require you to use your own `NSFetchedResultsControllerDelegate` class**

- `superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortedBy: NSString?, ascending: Bool, tableView: UITableView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController`
- `superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortedBy: NSString?, ascending: Bool, collectionView: UICollectionView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController`
- `superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortDescriptors: NSArray?, predicate: NSPredicate?, collectionView: UICollectionView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController`
- `superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortDescriptors: NSArray?, predicate: NSPredicate?, tableView: UITableView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController`
- `superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortDescriptors: NSArray?, predicate: NSPredicate?, collectionView: UICollectionView!, delegate: NSFetchedResultsControllerDelegate, context: NSManagedObjectContext!) -> NSFetchedResultsController`
- `superFetchedResultsController(entityName: NSString!, sectionNameKeyPath: NSString?, sortDescriptors: NSArray?, predicate: NSPredicate?, tableView: UITableView!, delegate: NSFetchedResultsControllerDelegate, context: NSManagedObjectContext!) -> NSFetchedResultsController`

##Developer Notes

This whole project is a work in progress, a learning exercise and has been released "early" so that it can be built and collaborated on with feedback from the community. I'm using it in a project I work on everyday, so hopefully it'll improve and gain more functionality, thread-safety and error handling over time.

Currently work is in progress to replace the SuperCoreDataStack with a much better, more flexible and cleaner implementation + a wiki is in progress. If you'd like to help out, please get in touch or open a PR.



----------

