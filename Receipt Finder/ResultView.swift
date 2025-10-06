//
//  ResultView.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 7/30/25.
//

import SwiftUI
import CoreData

struct ResultView: View {
    @Binding var fileName: String
    @State var searchText: String
    @Binding var selectedImage: UIImage?
    @State var selectedItem: Item?
    
    @State private var showScanner = false
    @State private var addNew = false
    @State private var recognizedText = ""   // raw OCR text
    @State private var navigateToSaveAs = false
    @State private var navigateToDetails = false
    @State private var isProcessing = false
    
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
    ) var items: FetchedResults<Item>
    
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    Section("Previous Activity") {
                        ForEach(filteredItems) { item in
                            Button {
                                selectedItem = item
                                navigateToDetails = true
                            } label: {
                                Text(item.name ?? "Unnamed")
                            }
                        }
                        .onDelete(perform: deleteItem)
                    }
                }
                
                Button("Add New Receipt") {
                    addNew = true
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.blue)
                .cornerRadius(15)
                .confirmationDialog("Select an option",
                                    isPresented: $addNew,
                                    titleVisibility: .visible) {
                    Button("Open Camera") {
                        showScanner = true
                    }
                    Button("Add from Library") {
                        // TODO: implement photo picker
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
            
            if isProcessing {
                Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                ProgressView("Processing...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
            }
        }
        .searchable(text: $searchText, prompt: "Search")
        
        // ✅ Navigation to Details (CoreData Item)
        .navigationDestination(isPresented: $navigateToDetails) {
            if let item = selectedItem {
                DetailsView(
                    item: item,
                    recognizedText: recognizedText // pass OCR text here
                )
            }
        }
        
        // ✅ Navigation to SaveAs
        .navigationDestination(isPresented: $navigateToSaveAs) {
            SaveAsView(
                fileName: "",
                searchText: searchText,
                selectedImage: $selectedImage
            )
            .environment(\.managedObjectContext, viewContext)
        }
        
        // ✅ Scanner
        .fullScreenCover(isPresented: $showScanner) {
            DocumentScannerView { images, text in
                isProcessing = true
                self.selectedImage = images.first
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.recognizedText = text
                    self.isProcessing = false
                    self.navigateToSaveAs = true
                }
            }
            .ignoresSafeArea(.all)
        }
    }
    
    // MARK: - Delete
    private func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            viewContext.delete(item)
        }
        try? viewContext.save()
    }
    
    // MARK: - Filtered Items
    private var filteredItems: [Item] {
        if searchText.isEmpty {
            return Array(items)
        } else {
            return items.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }
}

