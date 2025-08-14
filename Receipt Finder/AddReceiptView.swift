//
//  AddReceiptView.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 7/29/25.
//

import SwiftUI
import PhotosUI

struct AddReceiptView: View {
    @State var showcamera: Bool = false
    @State var selectedImage: UIImage?
    @State var savenav: Bool = false
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
                Button {
                    savenav = true
                } label: {
                    Text("Add Receipt")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(.blue)
                        .cornerRadius(15)
                }.navigationDestination(isPresented: $savenav) {
                    SaveAsView(selectedImage: $selectedImage)
                }
                   
                }
            }.padding(20)
        }
    }





#Preview {
    AddReceiptView()
    
}
