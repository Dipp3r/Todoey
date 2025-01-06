//
//  ShowView.swift
//  Todoey
//
//  Created by Arun K on 31/12/24.
//

import SwiftUI

struct TodoItemRow: View {
    @ObservedObject var item: TodoItem
    var onToggleCompletion: () -> Void
    var onDelete: () -> Void
    var onShowDetail: () -> Void
    var onEdit: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(item.title)
                    .fontWeight(.regular)
                Spacer()
                if item.isCompleted {
                    Image(systemName: K.Image.checkmark)
                        .scaleEffect(0.9)
                        .foregroundColor(.purple)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onToggleCompletion()
            }
            .swipeActions(allowsFullSwipe: true) {
                Button(role: .destructive, action: onDelete) {
                    Image(systemName: K.Image.trash).tint(.red)
                }
                if item.note.isEmpty {
                    Button(action: onEdit ) {
                        Image(systemName: K.Image.note)
                    }.tint(.orange)
                } else {
                    Button(action: onShowDetail ) {
                        Image(systemName: item.showNote ? K.Image.eyeslash : K.Image.eye)
                    }.tint(.blue)
                }
            }
            
            if item.showNote && !item.note.isEmpty {
                DescriptionView(with: item.note)
            }
        }
    }
}

struct DescriptionView: View {
    let inputText: String
    init(with input: String) {
        self.inputText = input
    }
    var body: some View {
        VStack{
            HStack {
                Text(inputText)
                    .font(.system(size: 15))
                    .foregroundColor(.purple)
                    .italic()
                Spacer()
            }
        }.padding(.all, 5)
    }
}


func previewTodoItem() -> TodoItem {
    let category = Category()
    category.name = "Sample category"
    let newItem = TodoItem()
    newItem.title = "Sample item"
    newItem.parentCategory = category
    newItem.note = "This is a sample item."
    newItem.isCompleted = false
    newItem.showNote = false
    return newItem
}

#Preview(traits: .sizeThatFitsLayout) {
    TodoItemRow(
        item: previewTodoItem(),
        onToggleCompletion: {
            print("Toggle completion tapped in preview.")
        },
        onDelete: {
            print("Delete tapped in preview.")
        },
        onShowDetail: {
            print("Show detail tapped in preview.")
        },
        onEdit: {
            print("Edit tapped in preview.")
        }
    )
}
