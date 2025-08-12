//
//  DetailsView.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 8/7/25.
//

import SwiftUI
struct DetailsView: View {
    @Binding var receiptName: String
    @Binding var selectedImage: UIImage?
    var body: some View {
        TextField(receiptName, text: $receiptName)
            .padding(10)
            .background(.gray.opacity(0.1))
            .cornerRadius(5)
            .padding()
        if let image = selectedImage{
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

#Preview {
    DetailsView(receiptName: .constant("Test"), selectedImage: .constant(UIImage(systemName: "photo")!))
}
