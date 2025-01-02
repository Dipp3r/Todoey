//
//  ContentView.swift
//  Todoey
//
//  Created by Arun K on 30/12/24.
//

import SwiftUI

struct ToDoListContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @State private var showDetail: Bool = false
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TodoItem.addedTime, ascending: true)], animation: .default) private var items: FetchedResults<TodoItem>
    
    var itemManager: ItemManager = ItemManager()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
            .foregroundColor: UIColor.systemPurple
        ]
        appearance.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 28, weight: .bold),
            .foregroundColor: UIColor.systemPurple
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        
    }
    
    // Helper property to group items by category
    private var groupedItems: [String: [TodoItem]] {
        Dictionary(grouping: items, by: { $0.category })
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if items.isEmpty {
                    emptyListView
                } else {
                    groupedItemList
                }
            }
            .navigationTitle(K.Title.navigation)
            .toolbar {
                addButton
            }
            .onAppear {
                // Load from UserDefaults
//                itemManager.loadUserDefaults()
            }
            .scrollContentBackground(.hidden)
            .background(Color(K.Color.background))
        }
        .onAppear(){
            itemManager.context = viewContext
        }
    }

    private var emptyListView: some View {
        VStack {
            ForEach(K.Empty.listView, id: \.self) { msg in
                Text(msg)
                    .foregroundColor(.secondary)
            }
        }
        .background(Color(.systemBackground))
    }

    private var groupedItemList: some View {
        List {
            ForEach(groupedItems.keys.sorted(), id: \.self) { category in
                Section(header: Text(category)) {
                    ForEach(groupedItems[category] ?? []) { item in
                        TodoItemRow(
                            item: item,
                            onToggleCompletion: { itemManager.toggleCompletion(for: item) },
                            onDelete: { withAnimation { itemManager.deleteItem(item) } },
                            onShowDetail: { itemManager.showDescription(for: item) },
                            onEdit: { print("Edit description pending") }
                        )
                    }
                }
            }
        }
    }

    private var addButton: some View {
        Button("+") {
            showDetail.toggle()
        }
        .sheet(isPresented: $showDetail) {
            AddItemView(itemManager)
        }
        .buttonStyle(.bordered)
        .font(.headline)
        .tint(.purple)
    }
}

#Preview {
    ToDoListContentView()
}
