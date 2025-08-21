//
//  SaveAsView.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 8/4/25.
//

import SwiftUI
import CoreData

struct SaveAsView: View{
    @State var fileName: String = ""
    @State var searchText: String = ""
    @State var shouldNavigate: Bool = false
    @State var showFileAlert: Bool = false
    @State var receiptAlert: Bool = false
    @State var okAlert: Bool = false
    @Binding var selectedImage: UIImage?
    
    @Environment(\.managedObjectContext) var  viewContext
    
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key:"id",ascending: true)]) var items: FetchedResults<Item>
    
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
            if !fileName.isEmpty{
                Button {
                    addItem()
                    receiptAlert = true
                    groupName()
                } label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(.blue)
                        .cornerRadius(15)
                }
            }
            else {
                Button {
                    showFileAlert = true
                } label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(.blue)
                        .cornerRadius(15)
                }.alert("Name not Found", isPresented: $showFileAlert){
                    
                }
            }
        } .alert("Added Receipt Successfully", isPresented: $receiptAlert) {
            Button {
                okAlert = true
            } label: {
                Text("OK")
            }
        }
        .navigationDestination(isPresented: $okAlert) {
            ResultView( fileName: $fileName, searchText: searchText, selectedImage: $selectedImage)
        }
    }
    
    func addItem(){
        let item = Item(context: viewContext)
        item.name = fileName
        item.id = UUID()
        
        if let image = selectedImage{
            item.image = image
        }
        
        do{
            try viewContext.save()
            fileName = ""
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func groupName(){
        if let firstWord = fileName.split(separator: " ").first {
            print(firstWord)  // Output: Hello
        }
    }
}

#Preview {
    SaveAsView(searchText: "hello", selectedImage: .constant(UIImage(systemName: "photo")))
}
