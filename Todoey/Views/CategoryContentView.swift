//
//  CategoryContentView.swift
//  Todoey
//
//  Created by Arun K on 3/1/25.
//

import SwiftUI

struct CategoryContentView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.itemManager) private var itemManager
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)], animation: .default) private var categories: FetchedResults<Category>
    
    @State private var showPopover: Bool = false
    @State private var editEnabled: Bool = false
    @State private var categoryName: String = K.Empty.text
    @State private var editState: String = "Edit"
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: ToDoListContentView(nil)) {
                    Text("View all todo items")
                        .foregroundColor(.purple)
                        .font(.callout)
                        .padding(.all, 10)
                }
                .disabled(editEnabled)
            }
            .scrollContentBackground(.hidden)
            .background(Color(K.Color.background))
            .scrollDisabled(true)
            .frame(maxHeight: 80)
            List(categories) { category in
                HStack {
                    if editEnabled {
                        Button(action: {
                            itemManager.deleteAllItems(withCategory: category)
                            self.context.delete(category)
                            saveContext()
                            if categories.isEmpty {
                                editEnabled = false
                            }
                        }) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 20, height: 20)
                                .overlay {
                                    Text("-")
                                        .tint(.white)
                                        .bold()
                                        .padding(.all, 5)
                                }
                        }
                        Divider()
                    }
                    
                    NavigationLink(destination: ToDoListContentView(category)) {
                        Text(category.name)
                    }
                    .disabled(editEnabled)
                    Spacer()
                }
            }
            .navigationTitle("Category")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        self.editEnabled.toggle()
                        editState = editEnabled ? "Done" : "Edit"
                    } label: {
                        Text(editState)
                            .tint(.blue)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    addButton
                }
                
            }
            .scrollContentBackground(.hidden)
            .background(Color(K.Color.background))
        }
        
    }
    
    private var addButton: some View {
        Button("+") {
//            self.editEnabled = false
            showPopover.toggle()
        }
        .alert("New Category", isPresented: $showPopover) {
            overlayView
        } message: {
            Text("Used to categorize your list of reminders")
            
        }
        .buttonStyle(.bordered)
        .font(.headline)
        .tint(.purple)
    }
    
    
    
    private func saveContext() {
        do {
            try context.save()
            print("successfully saved new category to the database")
        } catch {
            print("Error while saving new category to the database, \(error.localizedDescription)")
        }
    }
    
    private func submit() {
        let newCategort = Category(context: context)
        newCategort.name = categoryName
        saveContext()
        categoryName = ""
        
    }
    
    private var overlayView: some View {
        VStack {
            TextField("Name", text: $categoryName)
                .font(.subheadline)
            HStack {
                Button("cancel", action: {
                    self.categoryName = ""
                })
                Button("add", action: submit)
            }
        }
    }
    

}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    return CategoryContentView()
            .environment(\.managedObjectContext, context)
}
