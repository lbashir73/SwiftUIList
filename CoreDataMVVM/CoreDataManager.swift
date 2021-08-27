//
//  CoreDataManager.swift
//  CoreDataMVVM
//
//  Created by Lisa on 7/27/21.
//

import CoreData

class CoreDataManager {
    let persistentContainer : NSPersistentContainer
    
    static let shared = CoreDataManager()       // singleton
    
    private init() {
        persistentContainer = NSPersistentContainer( name: "ItemDataModel" )
        persistentContainer.loadPersistentStores { ( description, error ) in
            if let error = error {
                fatalError("Unable to initialize Core Data stack -  \( error.localizedDescription )")
            }
        }
    }
    
    func getItemById( id: NSManagedObjectID ) -> Item? {
        do {
            return try persistentContainer.viewContext.existingObject( with: id ) as? Item
        }
        catch  {
            return nil
        }
    }
    
    func delete( item: Item ) {
        persistentContainer.viewContext.delete( item )
        save()
    }
    
    func getAllItems() -> [Item] {
        var itemList = [Item]()
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemList = try persistentContainer.viewContext.fetch( request )
        }
        catch  {
            print( error.localizedDescription )
        }
        return itemList
    }
    
    func save() {
        do {
            try persistentContainer.viewContext.save()
        }
        catch  {
            persistentContainer.viewContext.rollback()
            print( error.localizedDescription )
        }
    }
}
