//
//  ContentView.swift
//  Todoey
//
//  Created by Arun K on 30/12/24.
//

import SwiftUI
import CoreData

struct ToDoListContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.itemManager) private var itemManager
    
    @FetchRequest var items: FetchedResults<TodoItem>
    
    @State private var showDetail: Bool = false
    @State private var searchText = ""
    
    private var selectedCategory: Category?
    
    init(_ category: Category?) {
        self.selectedCategory = category
        let predicate: NSPredicate? = category != nil ? NSPredicate(format: "parentCategory == %@", category!) : nil
        _items = FetchRequest<TodoItem>(
            sortDescriptors: [NSSortDescriptor(keyPath: \TodoItem.title, ascending: true)],
            predicate: predicate
        )
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
    
    private var filteredItems: [TodoItem] {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TodoItem.title, ascending: true)]
        do {
            return try viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    // Helper function to group items by category
    private func groupItems(from items: [TodoItem]) -> [String: [TodoItem]] {
        Dictionary(grouping: items, by: { $0.parentCategory.name })
    }
    
    // Filtered grouped items based on the search text
    private var filteredGroupedItems: [String: [TodoItem]] {
        searchText.isEmpty ? groupItems(from: Array(items)) : groupItems(from: filteredItems)
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
            .navigationTitle((selectedCategory?.name ?? K.Title.navigation) + " List")
            .toolbar {
                addButton
            }
            .onAppear {
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
            ForEach(filteredGroupedItems.keys.sorted(), id: \.self) { category in
                Section(header: Text(category)) {
                    ForEach(filteredGroupedItems[category] ?? []) { item in
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
        .searchable(text: $searchText)
    }

    private var addButton: some View {
        Button("+") {
            showDetail.toggle()
        }
        .sheet(isPresented: $showDetail) {
            AddItemView(itemManager, self.selectedCategory)
        }
        .buttonStyle(.bordered)
        .font(.headline)
        .tint(.purple)
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    return ToDoListContentView(nil)
            .environment(\.managedObjectContext, context)
}
