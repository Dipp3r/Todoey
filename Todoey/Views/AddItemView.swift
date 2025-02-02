//
//  DetailView.swift
//  Todoey
//
//  Created by Arun K on 30/12/24.
//

import SwiftUI
import CoreData

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var titleText: String = K.Empty.text
    @State var noteText: String = K.Empty.text
    @State private var selectedCategory: Category?
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)], animation: .default)
    private var categories: FetchedResults<Category>
    
    var itemManager: ItemManager
    var currentCategory: Category?
    
    init(_ itemManager: ItemManager, _ category: Category?) {
        self.itemManager = itemManager
        self.currentCategory = category
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Title and Note fields
                VStack {
                    TextField(K.Title.text, text: $titleText)
                        .frame(height: 50)
                        .background(Color(K.Color.textbox))
                        .cornerRadius(5)
                        .padding(.leading)
                        .font(.none)
                    Divider()
                        .padding(.leading, 20)
                    TextEditor(text: $noteText)
                        .background(Color(K.Color.textbox))
                        .scrollContentBackground(.hidden)
                        .padding(.leading)
                        .frame(maxHeight: 150)
                        .cornerRadius(5)
                        .font(.none)
                }
                .background(Color(K.Color.textbox))
                .cornerRadius(10)
                
                // Display selected category
                if let safeCategory = currentCategory {
                    HStack {
                        Image(systemName: K.Image.listbullet)
                            .foregroundColor(.purple)
                        Text("\(safeCategory.name)")
                        Spacer()
                    }
                    .padding(.all)
                } else {
                    Menu {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                HStack {
                                    Text(category.name)
                                    if selectedCategory == category {
                                        Spacer()
                                        Image(systemName: K.Image.checkmark)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    } label: {
                        List{
                            Label(selectedCategory?.name ?? "Choose a category", systemImage: K.Image.listbullet)
                        }
                        .font(.none)
                        .frame(maxWidth: .infinity, maxHeight: 100)
                    }
                    .background(Color(K.Color.background))
                    .scrollContentBackground(.hidden)
                    .onAppear {
                        // Automatically select the first category if available
                        if selectedCategory == nil, let firstCategory = categories.first {
                            selectedCategory = firstCategory
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.all, 20)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(K.Title.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if let selectedCategory = selectedCategory {
                            itemManager.addItem(title: self.titleText, category: selectedCategory, note: self.noteText)
                        } else {
                            itemManager.addItem(title: self.titleText, category: currentCategory!, note: self.noteText)
                        }
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(K.Title.add)
                            .fontWeight(.bold)
                    }
                    .disabled(titleText.isEmpty)
                }
            }
            .background(Color(K.Color.background))
        }
    }
}

#Preview {
    @Previewable @Environment(\.managedObjectContext) var viewContext
    AddItemView(ItemManager(viewContext), nil)
}
