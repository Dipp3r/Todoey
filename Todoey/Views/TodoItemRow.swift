//
//  ShowView.swift
//  Todoey
//
//  Created by Arun K on 31/12/24.
//

import SwiftUI

struct TodoItemRow: View {
    var item: TodoItem
    var onToggleCompletion: () -> Void
    var onDelete: () -> Void
    var onShowDetail: () -> Void
    var onEdit: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("\(item.title)")
                    .fontWeight(.regular)
                Spacer()
                if item.isCompleted {
                    Image(systemName: "checkmark")
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
                    Image(systemName: "trash").tint(.red)
                }
                if item.note.isEmpty {
                    Button(action: onEdit ) {
                        Image(systemName: "square.and.pencil")
                    }.tint(.orange)
                } else {
                    Button(action: onShowDetail ) {
                        Image(systemName: item.showNote ? "eye.slash" : "eye")
                    }.tint(.blue)
                }
            }
            
            if item.showNote && !item.note.isEmpty {
                VStack{
                    HStack {
                        Text(item.note)
                            .font(.system(size: 15))
                            .foregroundColor(.purple)
                            .italic()
                        Spacer()
                    }
                }.padding(.all, 5)
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TodoItemRow(
        item: TodoItem(
            title: "Sample Todo",
            description: "buy 1 egg",
            category: "Groceries"
        ),
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
