//
//  ResultView.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 7/30/25.
//

import SwiftUI

struct ResultView: View {
    
    @Binding var fileName: String
    @State var searchText: String
    @Binding var selectedImage: UIImage?
    @State var selectedItem: Item?
    
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key:"id",ascending: true)]) var items: FetchedResults<Item>
    @Environment(\.managedObjectContext) var  viewContext
    
    var body: some View {
        VStack {
            List {
                Section("Result"){
                    Text("Receipt Added Successfully!")
                        .font(.headline)
                }
                Section("Previous Activity") {
                    ForEach(filteredItems) { item in
                        Button {
                            selectedItem = item
                        } label: {
                            Text(item.name ?? "Unnamed")
                        }
                    }.onDelete(perform: deleteItem)
                }
            }
        }
        .navigationBarItems(
            trailing: NavigationLink("Add", destination: AddReceiptView())
        )
        .searchable(text: $searchText, prompt: "Search")
        .navigationDestination(item: $selectedItem){ item in
            DetailsView(item: item)
        
        }
    }
    func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            viewContext.delete(item)
            
            do{
                try viewContext.save()
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    var filteredItems: [Item] {
            if searchText.isEmpty {
                return Array(items)
            } else {
                return items.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
            }
        }
}

#Preview {
    ResultView(fileName: .constant("Test"), searchText:"hello", selectedImage: .constant(UIImage(systemName: "photo")))
}
