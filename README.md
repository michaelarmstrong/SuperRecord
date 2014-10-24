SuperRecord 
===================

A **Swift CoreData extension** to bring some love and take the hassle out of common CoreData tasks.

----------
Each piece of functionality can be used independently and discreetly, so there is no need for a "buy in" to the whole project. For example, you could use your own `NSFetchedResultsController` or `NSManagedObjectContext` with any of the finders or even the `SuperFetchedResultsControllerDelegate`

I'd like to make a big shout-out to MagicalRecord, which I think lay great foundations for these kind of projects. Although its had its ups and downs, it seems under heavy development. This Swift SuperRecord project was obviously heavily inspired by work done in MagicalRecord.

Features
-------------

SuperRecord consists of several Extensions to add MagicalRecord/ActiveRecord style "finders" to your NSManagedObject subclasses, a **FetchResultsControllerDelegate** class to handle safe batch updates to both **UITableView** and **UICollectionView** and an experimental Boilerplate CoreData Stack Singleton.  

The project has been built over several versions of Swift so some choices may seem strange at first. **Please see the included Demo Project for more information and a closer look.**

*Swift code doesn't yet work with cocoapods, so its best to use this as a submodule for now.

> **Files:**

> - **NSManagedObjectExtension.swift** 
>      This extension is responsible for most of the "finder" functionality and has operations such as `deleteAll()`, `findOrCreateWithAttribute()` `createEntity()` and allows you to specify your own `NSManagedObjectContext` or use the default one (running on the main thread).
>      
<br>
> - **NSFetchedResultsControllerExtension.swift**
> In constant development, this Extension allows the easy creation of `FetchedResultsControllers` for use with `UICollectionView` and `UITableView` that utilise the `SuperFetchedResultsControllerDelegate` for safe batch updates.
<br>
> - **SuperFetchedResultsControllerDelegate.swift** heavily inspired by past-projects i've worked on along with other popular open source projects. This handles **safe batch updates** to `UICollectionView` and `UITableView` across iOS 7 and iOS 8. It can be used on its own with your `NSFetchedResultsController` or alternatively, its automatically used by the `NSFetchedResultsControllerExtension` methods included in **SuperRecord**.

## Usage

#### <i class="icon-file"></i> Create a new Entity
Assuming you have an NSManagedObject of type "Pokemon" you could do the following

`let pokemon = Pokemon.createNewEntity() as Pokemon`

Please add `@objc(className)` above the class name of all your `NSManagedObject` subclasses (as shown in the demo project) for now. Better support will be coming in the future.

#### <i class="icon-folder-open"></i> Creating an NSFetchedResultsController
This feature is currently in progress with basic support so far, in future versions, sorting and sectionNameKeyPath's will be supported. Until then you can create your own NSFetchedResultsController, however, if you have no need for the above missing functionality then simply use

```
lazy var fetchedResultsController: NSFetchedResultsController = self.superFetchedResultsController()

func superFetchedResultsController() -> NSFetchedResultsController {
return NSFetchedResultsController.superFetchedResultsController("Pokemon", tableView: tableView)
}
```

With `Pokemon` being the entity name of your `NSManagedObject`.


#### <i class="icon-trash"></i> Delete Entities

I'm planning on adding much more powerful functionality around Delete soon, such as deleteAllWithPredicate() or deleteEntity(), right now all that is available is

`Pokemon.deleteAll()`


### Method Listing
This isn't an exhaustive list of all methods and classes, however it includes some of the most useful ones.

- **NSManagedObjectExtension**
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


- **NSFetchedResultsControllerExtension**
- `superFetchedResultsController(entityName: NSString!, collectionView: UICollectionView) -> NSFetchedResultsController`
- `superFetchedResultsController(entityName: NSString!, tableView: UITableView) -> NSFetchedResultsController`

`NSFetchedResultsControllers` created using this method will automatically handle safe batch updates.



##Developer Notes

This whole project is a work in progress, a learning exercise and has been released "early" so that it can be built and collaborated on with feedback from the community. I'm using it in a project I work on everyday, so hopefully it'll improve and gain more functionality, thread-safety and error handling over time.

The next key things to be worked on are Optionality (as this has changed in every Swift BETA), the CoreDataStack, adding more finders with more functionality and improving the NSFetchedResultsControllerExtension.



----------

