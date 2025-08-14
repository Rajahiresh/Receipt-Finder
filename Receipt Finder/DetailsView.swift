//
//  DetailsView.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 8/7/25.
//

import SwiftUI
struct DetailsView: View {
    
    var item: Item
    var body: some View {
        if let fileName = item.name {
            Text(fileName)
                .padding(10)
                .background(.gray.opacity(0.1))
                .cornerRadius(5)
                .padding()
        }
        if let image = item.image as? UIImage{
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(20)
        }else{
            Text("No Image Selected")
        }
    }
}

//#Preview {
 //   let previewItem = Item(context: PersistenceController.shared.container.viewContext)
 //   DetailsView(fileName: .constant("Test"),
               // previewItem.image = UIImage(systemName: "photo"))
//}

//#Preview {
    // Mock preview item
  //  let previewItem = Item(context: PersistenceController.shared.container.viewContext)
    //previewItem.name = "Test Receipt"
    //previewItem.image = UIImage(systemName: "photo")
//}
