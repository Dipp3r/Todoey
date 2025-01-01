//
//  DetailView.swift
//  Todoey
//
//  Created by Arun K on 30/12/24.
//

import SwiftUI
import CoreData

struct AddItemView: View {
    
    @State var titleText: String = ""
    @State var noteText: String = ""
    
    var categories: [String] = ["General", "Groceries", "Work", "Personal", "Finance", "Games", "Shopping", "Travel & Vacation", "Food & Drinks", "Sports", "Emergency"].reversed()
    
    @State private var selectedCategory: String = "General"
    
    let defaults = UserDefaults.standard
    
    @ObservedObject var itemManager: ItemManager
    @Environment(\.presentationMode) var presentationMode
    
    init(_ itemManager: ItemManager){
        self.itemManager = itemManager
    }
    
    var body: some View {
        NavigationView{
            VStack {
                VStack {
                    TextField("Title", text: $titleText)
                        .frame(height: 50)
                        .background(Color("TextBoxColor"))
                        .cornerRadius(5)
                        .padding(.leading)
                        .font(.none)
                    Divider()
                        .padding(.leading, 20)
                    TextEditor(text: $noteText)
                        .background(Color("TextBoxColor"))
                        .scrollContentBackground(.hidden)
                        .padding(.leading)
                        .frame(maxHeight: 150)
                        .cornerRadius(5)
                        .font(.none)
                }
                .background(Color("TextBoxColor"))
                .cornerRadius(10)
                Menu {
                    // Create a menu item for each category
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            HStack {
                                Text(category)
                                if selectedCategory == category {
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                } label: {
                    List{
                        Label(selectedCategory, systemImage: "list.bullet")
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100) //
                    
                }
                .background(Color("BackgroundColor"))
                .scrollContentBackground(.hidden)
                Spacer()
            }
            
            .padding(.all, 20)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.none)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        itemManager.addItem(title: self.titleText, category: self.selectedCategory, note: self.noteText)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Add")
                            .fontWeight(.bold)
                    }
                    .disabled(titleText.isEmpty ? true : false)
                    .font(.none)

                }
            }
            .background(Color("BackgroundColor"))
        }
    }
}

#Preview {
    AddItemView(ItemManager())
}
