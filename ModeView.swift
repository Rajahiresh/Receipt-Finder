//
//  ModeView.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 8/21/25.
//

import SwiftUI

struct ModeView: View {
    @State var addNew: Bool = false
    @State var viewAll: Bool = false
    @State var fileName: String = ""
    @State var searchText: String = ""
    @State var selectedImage: UIImage? = nil
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 10) {
                Button {
                    viewAll.toggle()
                } label: {
                    Text("View All Receipts")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(.blue)
                        .cornerRadius(15)
                }.navigationDestination(isPresented: $viewAll) {
                    ResultView(fileName: $fileName, searchText: searchText, selectedImage: $selectedImage)
                }
                Button {
                    addNew.toggle()
                } label: {
                    Text("Add New Receipt")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(.blue)
                        .cornerRadius(15)
                }.navigationDestination(isPresented: $addNew) {
                    AddReceiptView()
                }
            }
        }
    }
} 
#Preview {
    ModeView()
}
