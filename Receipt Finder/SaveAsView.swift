//
//  SaveAsView.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 8/4/25.
//

import SwiftUI

struct SaveAsView: View{
    @State var fileName: String = ""
    @State var savedFiles: [String] = []
    @State var shouldNavigate: Bool = false
    @Binding var selectedImage: UIImage?
    var body: some View{
        
        VStack{
            HStack{
                Text("File Name:")
                    .font(.headline)
                TextField("Enter File Name", text: $fileName)
                    .padding(10)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(10)
            }.padding()
            if let image = selectedImage{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(20)
            }
            Spacer(minLength:20)
            Button {
                savedFiles.append(fileName)
                shouldNavigate.toggle()
            } label: {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(.blue)
                    .cornerRadius(15)
            }
            
            }.navigationDestination(isPresented: $shouldNavigate) {
                    ResultView(Names: savedFiles, selectedImage: $selectedImage)
                }
        }
    }



#Preview {
    SaveAsView(selectedImage: .constant(UIImage(systemName: "photo")!))
}
