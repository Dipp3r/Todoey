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
    @State private var selectedCategory: String = K.Category.general
    
    
    var itemManager: ItemManager
    var categories: [String] = K.Category.list.reversed()
    
    
    init(_ itemManager: ItemManager){
        self.itemManager = itemManager
    }
    
    var body: some View {
        NavigationView{
            VStack {
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
                                    Image(systemName: K.Image.checkmark)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                } label: {
                    List{
                        Label(selectedCategory, systemImage: K.Image.listbullet)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100) //
                    
                }
                .background(Color(K.Color.background))
                .scrollContentBackground(.hidden)
                Spacer()
            }
            
            .padding(.all, 20)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(K.Title.cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.none)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        itemManager.addItem(title: self.titleText, category: self.selectedCategory, note: self.noteText)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(K.Title.add)
                            .fontWeight(.bold)
                    }
                    .disabled(titleText.isEmpty ? true : false)
                    .font(.none)

                }
            }
            .background(Color(K.Color.background))
        }
    }
}

#Preview {
    @Previewable @Environment(\.managedObjectContext) var viewContext
    AddItemView(ItemManager(viewContext))
}
