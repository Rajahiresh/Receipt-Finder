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
    @State var shouldNavigate: Bool = false
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
            Button {
                shouldNavigate.toggle()
                addItem()
            } label: {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(.blue)
                    .cornerRadius(15)
            }
            
            }.navigationDestination(isPresented: $shouldNavigate) {
                ResultView( fileName: $fileName,selectedImage: $selectedImage)
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
}



#Preview {
    SaveAsView(selectedImage: .constant(UIImage(systemName: "photo")))
}
