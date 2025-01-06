//
//  TodoItem+CoreDataProperties.swift
//  Todoey
//
//  Created by Arun K on 3/1/25.
//
//

import Foundation
import CoreData


extension TodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var addedTime: Date
    @NSManaged public var isCompleted: Bool
    @NSManaged public var note: String
    @NSManaged public var showNote: Bool
    @NSManaged public var title: String
    @NSManaged public var parentCategory: Category

}

extension TodoItem : Identifiable {

}
