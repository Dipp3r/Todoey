//
//  TodoItem.swift
//  Todoey
//
//  Created by Arun K on 30/12/24.
//

import Foundation
import SwiftUI

struct TodoItem: Identifiable, Codable {
    
    let id: String
    let title: String
    let note: String
    let category: String
    var showNote: Bool = false
    
    var isCompleted: Bool = false
    
    init(title text: String, description: String = "", category: String) {
        self.title = text 
        self.note = description
        self.category = category
        self.id = UUID().uuidString
    }
}
