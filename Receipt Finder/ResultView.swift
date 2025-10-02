//
//  ResultView.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 7/30/25.
//

import SwiftUI

struct ResultView: View {
    
    @Binding var fileName: String
    @State var searchText: String
    @Binding var selectedImage: UIImage?
    @State var selectedItem: Item?
    
    @State private var showScanner = false
    @State private var addNew = false
    @State private var recognizedText = ""
    @State private var navigateToSaveAs = false
    @State private var isProcessing = false   // ✅ Loading state
    
    @FetchRequest(entity: Item.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)])
    var items: FetchedResults<Item>
    
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    Section("Previous Activity") {
                        ForEach(filteredItems) { item in
                            Button {
                                selectedItem = item
                            } label: {
                                Text(item.name ?? "Unnamed")
                            }
                        }
                        .onDelete(perform: deleteItem)
                    }
                }
                
                Button {
                    addNew = true
                } label: {
                    Text("Add New Receipt")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
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
            
            // ✅ Show loading overlay when processing OCR
            if isProcessing {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                ProgressView("Processing...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
            }
        }
        .searchable(text: $searchText, prompt: "Search")
        
        // Navigation
        .navigationDestination(item: $selectedItem) { item in
            DetailsView(item: item)
        }
        .navigationDestination(isPresented: $navigateToSaveAs) {
            SaveAsView(
                fileName: "",
                searchText: searchText,
                selectedImage: $selectedImage
            )
        }
        
        // Scanner fullscreen cover
        .fullScreenCover(isPresented: $showScanner) {
            DocumentScannerView { images, text in
                isProcessing = true  // Start loading indicator
                
                self.selectedImage = images.first
                
                // OCR complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.recognizedText = text
                    self.isProcessing = false
                    self.navigateToSaveAs = true
                }
            }
            .ignoresSafeArea(.all)
        }
    }
    
    // MARK: - Delete Item
    private func deleteItem(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            viewContext.delete(item)
            
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
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
