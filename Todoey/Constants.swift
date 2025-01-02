//
//  Constants.swift
//  Todoey
//
//  Created by Arun K on 2/1/25.
//

import Foundation

struct K {
    
    struct Category {
        static let list: [String] = ["General", "Groceries", "Work", "Personal", "Finance", "Games", "Shopping", "Travel & Vacation", "Food & Drinks", "Sports", "Emergency"]
        static let general: String = "General"
    }
    struct Empty {
        static let text: String = ""
        static let listView: [String] = ["Your list is empty", "Add an item to get started!"]
    }
    
    struct Title {
        static let navigation: String = "Todo List"
        static let text: String = "Title"
        static let cancel: String = "cancel"
        static let add: String = "add"
    }
    
    struct Color {
        static let background: String = "BackgroundColor"
        static let textbox: String = "TextBoxColor"
    }
    
    struct Image {
        static let checkmark: String = "checkmark"
        static let trash: String = "trash"
        static let note: String = "square.and.pencil"
        static let eye: String = "eye"
        static let eyeslash: String = "eye.slash"
        static let listbullet: String = "list.bullet"
    }
}
