//
//  ItemManager.swift
//  Todoey
//
//  Created by Arun K on 30/12/24.
//


import SwiftUI

class ItemManager: ObservableObject {
    
    @Published var itemArray: [TodoItem] = []
    
    private var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    func addItem(title: String, category: String, note: String) {
        itemArray.append(TodoItem(title: title, description: note, category: category))
        // Set UserDefaults
        self.setUserDefaults()
    }

    
    func deleteItem(_ item: TodoItem) {
        if let index = itemArray.firstIndex(where: { $0.id == item.id }) {
            itemArray.remove(at: index)
        }
        // Set UserDefaults
        self.setUserDefaults()
    }
    
    func toggleCompletion(for item: TodoItem) {
        if let index = itemArray.firstIndex(where: { $0.id == item.id }) {
            itemArray[index].isCompleted.toggle()
        }
        // Set UserDefaults
        self.setUserDefaults()
    }
    
    func showDescription(for item: TodoItem) {
        if let index = itemArray.firstIndex(where: { $0.id == item.id }) {
            itemArray[index].showNote.toggle()
        }
        // Set UserDefaults
        self.setUserDefaults()
    }
    
    func setUserDefaults() {
        let encoder = PropertyListEncoder()
        if let encodedData = try? encoder.encode(self.itemArray) {
            do {
                try encodedData.write(to: dataFilePath!)
            } catch {
                print("Error writing encoded data to FilePath: \(String(describing: dataFilePath)). ERROR> \(error.localizedDescription)")
            }
        }
    }
    
    func loadUserDefaults() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            if let loadedItems = try? decoder.decode([TodoItem].self, from: data) {
                self.itemArray = loadedItems
            }
        }
    }
}
