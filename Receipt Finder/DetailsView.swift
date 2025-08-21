//
//  DetailsView.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 8/7/25.
//

import SwiftUI
import Vision

struct DetailsView: View {
    
    @State private var recognizedText: String = ""
    @State private var fullText: String = ""
    @State private var fullScreenImage: Bool = false
    
    var item: Item
    
    var body: some View {
        VStack {
                Button {
                    recognizeText(for: item)
                } label: {
                    if let fileName = item.name {
                        Text(fileName)
                            .padding(10)
                            .background(.gray.opacity(0.1))
                            .cornerRadius(5)
                            .padding()
                    }
                }
                
                HStack {
                    TextEditor(text: $recognizedText)
                        .frame(minWidth: 150, maxHeight: .infinity)
                    
                    if let image = item.image as? UIImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(20)
                            .onTapGesture {
                                fullScreenImage = true
                            }
                            .fullScreenCover(isPresented: $fullScreenImage) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .onTapGesture {
                                        fullScreenImage = false
                                    }
                            }
                    }
                }
        }
    }
    
    func recognizeText(for item: Item) {
        guard let image = item.image as? UIImage,
              let cgImage = image.cgImage else { return }
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { request, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            guard let result = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            let recogArr = result.compactMap { result in
                result.topCandidates(1).first?.string
            }
            
            DispatchQueue.main.async {
                fullText = recogArr.joined(separator: "\n")
                recognizedText = extractImportantInfo(from: fullText)
            }
        }
        
        request.recognitionLevel = .accurate
        do {
            try handler.perform([request])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func extractImportantInfo(from text: String) -> String {
        var info = [String]()
        
        if let match = text.range(of: "(?i)GRAND TOTAL\\s*\\$?\\s*[0-9]+(\\.[0-9]{2})?", options: .regularExpression) {
            info.append("Grand Total: \(text[match])")
        }
        
        if let match = text.range(of: "\\d{1,2}/\\d{1,2}/\\d{4}", options: .regularExpression) {
            info.append("Date: \(text[match])")
        }
        
        if let cardLine = text.components(separatedBy: "\n").first(where: {
            $0.localizedCaseInsensitiveContains("AMEX") ||
            $0.localizedCaseInsensitiveContains("VISA") ||
            $0.localizedCaseInsensitiveContains("MASTER") ||
            $0.localizedCaseInsensitiveContains("DISCOVER")
        }) {
            let parts = cardLine.split(separator: " ")
            if let cardType = parts.first {
                info.append("Payment Type: Credit Card (\(cardType))")
            }
            if let lastPart = parts.last, lastPart.count >= 4 {
                info.append("Card Number: \(lastPart)")
            }
        } else if text.localizedCaseInsensitiveContains("CREDIT CARD") {
            info.append("Payment Type: Credit Card")
        } else if text.localizedCaseInsensitiveContains("DEBIT CARD") {
            info.append("Payment Type: Debit Card")
        } else if text.localizedCaseInsensitiveContains("CASH") {
            info.append("Payment Type: Cash")
        }
        
        if let firstLine = text.components(separatedBy: "\n").first {
            info.append("Store: \(firstLine)")
        }
        
        return info.joined(separator: "\n")
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



