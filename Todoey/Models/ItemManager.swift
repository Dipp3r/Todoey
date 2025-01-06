//
//  ItemManager.swift
//  Todoey
//
//  Created by Arun K on 30/12/24.
//


import SwiftUI
import CoreData

class ItemManager {
    
    static public var singleton = ItemManager()
    
    var context: NSManagedObjectContext
    
    init(_ viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext){
        self.context = viewContext
    }
    
    func addItem(title: String, category: Category, note: String) {
        let newItem = TodoItem(context: context)
        newItem.parentCategory = category
        newItem.title = title
        newItem.isCompleted = false
        newItem.note = note
        newItem.showNote = false
        newItem.addedTime = Date()
        saveContext()
    }
    
    func deleteAllItems(withCategory category: Category) {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        request.predicate = NSPredicate(format: "parentCategory == %@", category)
        do {
            let items = try context.fetch(request)
            for item in items {
                context.delete(item)
            }
        } catch {
            print("Error while deleting items with category: \(category.name), E: \(error.localizedDescription)")
        }
    }
    
    func saveContext(){
        withAnimation(.none) {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }

    func deleteItem(_ item: TodoItem) {
            context.delete(item)
            saveContext()
    }
    
    func toggleCompletion(for item: TodoItem) {
            item.isCompleted.toggle()
            saveContext()
    }
    
    func showDescription(for item: TodoItem) {
            item.showNote.toggle()
            saveContext()
    }
}
