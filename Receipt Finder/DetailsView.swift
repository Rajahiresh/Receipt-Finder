//
//  DetailsView.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 8/7/25.
//

import SwiftUI
import Vision

struct DetailsView: View {
    
    var item: Item
    
    @State private var fullScreenImage: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 15) {
                
                Spacer()
                if let fileName = item.name {
                    Text(fileName)
                        .font(.headline)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                        .padding(.horizontal)
                }
                if let image = item.image as? UIImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                        .onTapGesture {
                            fullScreenImage.toggle()
                        }.fullScreenCover(isPresented: $fullScreenImage){
                            ZoomableFullScreenImage(image: image, fullScreenImage: $fullScreenImage)
                        }
                }
                
                Divider()
                
                
                }
            }
        }
    }


#Preview {
    {
        let previewItem = Item(context: PersistenceController.shared.container.viewContext)
        previewItem.name = "Test Receipt"
        previewItem.id = UUID()
        previewItem.image = UIImage(systemName: "photo") // or .pngData() if your Core Data stores Data
        
        return DetailsView(item: previewItem)
    }()
}



