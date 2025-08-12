//
//  AddReceiptView.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 7/29/25.
//

import SwiftUI
import PhotosUI
import CoreData


struct AddReceiptView: View {
    @State var showcamera: Bool = false
    @State var selectedImage: UIImage?
    var body: some View {
        VStack {
            Spacer()
            Button {
                showcamera.toggle()
                
            } label: {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Image(systemName: "photo.badge.plus")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.black)
                }
            }.sheet(isPresented:$showcamera){
                CameraView(image: $selectedImage)
            }
            Spacer()
            VStack {
                NavigationLink(destination: SaveAsView(selectedImage: $selectedImage)) {
                    Text("Add Receipt")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(.blue)
                        .cornerRadius(15)
                }.padding(30)
            }
        }.padding()
    }
}

func addReceipt(name: String, image: UIImage?) {
    let ctx = CoreDataManager.shared.context
    let obj = NSEntityDescription.insertNewObject(forEntityName: "Receipt", into: ctx)
    obj.setValue(name, forKey: "name")
    if let data = image?.jpegData(compressionQuality: 0.9) {
        obj.setValue(data, forKey: "imageData")
    }
    CoreDataManager.shared.save()
}


#Preview {
    AddReceiptView()
    
}
