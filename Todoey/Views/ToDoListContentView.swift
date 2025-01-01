//
//  ContentView.swift
//  Todoey
//
//  Created by Arun K on 30/12/24.
//

import SwiftUI

struct ToDoListContentView: View {
    
    @ObservedObject var itemManager = ItemManager()
    @State private var showDetail: Bool = false
    
    var defaults = UserDefaults.standard
    
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
        Dictionary(grouping: itemManager.itemArray, by: { $0.category })
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if itemManager.itemArray.isEmpty {
                    emptyListView
                } else {
                    groupedItemList
                }
            }
            .navigationTitle("Todo List")
            .toolbar {
                addButton
            }
            .onAppear {
                // Load from UserDefaults
                itemManager.loadUserDefaults()
            }
            .scrollContentBackground(.hidden)
            .background(Color("BackgroundColor"))
        }
    }

    private var emptyListView: some View {
        VStack {
            Text("Your list is empty")
                .foregroundColor(.secondary)
            Text("Add an item to get started!")
                .foregroundColor(.secondary)
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
