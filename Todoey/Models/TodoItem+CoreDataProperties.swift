//
//  TodoItem+CoreDataProperties.swift
//  Todoey
//
//  Created by Arun K on 1/1/25.
//
//

import Foundation
import CoreData


extension TodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var category: String
    @NSManaged public var note: String
    @NSManaged public var showNote: Bool
    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String
    @NSManaged public var addedTime: Date
    

}

extension TodoItem : Identifiable {

}
