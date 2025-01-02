//
//  ItemManager.swift
//  Todoey
//
//  Created by Arun K on 30/12/24.
//


import SwiftUI
import CoreData

class ItemManager {
    
    var context: NSManagedObjectContext
    
    init(_ viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext){
        self.context = viewContext
    }
    
    func addItem(title: String, category: String, note: String) {
        let newItem = TodoItem(context: context)
        newItem.category = category
        newItem.title = title
        newItem.isCompleted = false
        newItem.note = note
        newItem.showNote = false
        newItem.addedTime = Date()
        saveContext()
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
