//
//  ItemListViewModel.swift
//  CoreDataMVVM
//
//  Created by Lisa on 7/27/21.
//

import CoreData

class ItemListViewModel: ObservableObject {
    var name: String = ""
    @Published var items: [ItemViewModel] = []
    
    func getAllItems() {
        items = CoreDataManager.shared.getAllItems().map( ItemViewModel.init )
    }
    
    func delete( item: ItemViewModel ) {
        let item = CoreDataManager.shared.getItemById( id: item.id )
        if let item = item {
            CoreDataManager.shared.delete( item: item )
        }
    }
    
    func  save() {
        let item = Item( context: CoreDataManager.shared.persistentContainer.viewContext )
        item.name = name
        item.dateCreated = Date()
        CoreDataManager.shared.save()
    }
    
    
    struct ItemViewModel {
        let item: Item
        
        var id: NSManagedObjectID {
            item.objectID
        }
        var name: String {
            return item.name ?? ""
        }
        var dateCreated: Date {
            return item.dateCreated ?? Date()
        }
    }
}
