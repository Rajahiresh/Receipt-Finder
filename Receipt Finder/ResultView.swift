//
//  ResultView.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 7/30/25.
//

import SwiftUI

struct ResultView: View {

    @Binding var fileName: String
    @Binding var selectedImage: UIImage?
    @State var selectedItem: Item?
    
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key:"id",ascending: true)]) var items: FetchedResults<Item>
    
    var body: some View {
        VStack {
            Text("Receipt Added Successfully!")
                .font(.title)
            List {
                Section("Previous Activity") {
                    ForEach(items) { item in
                        Button {
                            selectedItem = item
                        } label: {
                            Text(item.name ?? "Unnamed")
                        }
                    }
                }
            }
        }
        .navigationBarItems(
            trailing: NavigationLink("Add", destination: AddReceiptView())
        )
        .navigationDestination(item: $selectedItem){ item in
            DetailsView(item: item)
            }
    }
}

#Preview {
    ResultView(fileName: .constant("Test"), selectedImage: .constant(UIImage(systemName: "photo")))
}
