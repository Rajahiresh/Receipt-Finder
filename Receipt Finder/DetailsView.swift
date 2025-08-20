//
//  DetailsView.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 8/7/25.
//

import SwiftUI
import Vision

struct DetailsView: View {
    
    @State var recognizedText: String = ""
    @State var fullText: String = ""
    var item: Item
    
    var body: some View {
        Button {
            recognizeText()
        } label: {
            if let fileName = item.name {
                Text(fileName)
                    .padding(10)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(5)
                    .padding()
            }
        }
        
        TextEditor(text: $recognizedText)
        
        if let image = item.image as? UIImage{
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(20)
        }else{
            Text("No Image Selected")
        }
    }
    
    func recognizeText() {
        let image = item.image as! UIImage
        
        guard let cgImage = image.cgImage else { return }
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest{request, error in
            guard  error == nil else{
                print(error?.localizedDescription ?? "")
                return
            }
            
            guard let result = request.results as? [VNRecognizedTextObservation]
            else {
                return
            }
            
            let recogArr = result.compactMap{ result in
                result.topCandidates(1).first?.string
            }
            
            DispatchQueue.main.async {
                fullText = recogArr.joined(separator: "\n")
                recognizedText = extractImportantInfo(from: fullText)
            }
        }
        
        request.recognitionLevel = .accurate
        
        do{
            try handler.perform([request])
        }catch{
            print(error.localizedDescription)
        }
    }
    func extractImportantInfo(from text: String) -> String {
        var info = [String]()
        
        // Extract Grand Total (more specific)
        if let match = text.range(of: "(?i)GRAND TOTAL\\s*\\$?\\s*[0-9]+(\\.[0-9]{2})?", options: .regularExpression) {
            info.append("Grand Total: \(text[match])")
        }
        
        // Extract Date (first MM/DD/YYYY found)
        if let match = text.range(of: "\\d{1,2}/\\d{1,2}/\\d{4}", options: .regularExpression) {
            info.append("Date: \(text[match])")
        }
        
        // Extract Payment Type + Card Number
        if let cardLine = text.components(separatedBy: "\n").first(where: { $0.localizedCaseInsensitiveContains("AMEX") || $0.localizedCaseInsensitiveContains("VISA") || $0.localizedCaseInsensitiveContains("MASTER") || $0.localizedCaseInsensitiveContains("DISCOVER") }) {
            
            // Example: "AMEX ********1020"
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
        
        // Extract Store (first line is usually store name)
        if let firstLine = text.components(separatedBy: "\n").first {
            info.append("Store: \(firstLine)")
        }
        
        return info.joined(separator: "\n")
    }
}

//#Preview {
 //   let previewItem = Item(context: PersistenceController.shared.container.viewContext)
 //   DetailsView(fileName: .constant("Test"),
               // previewItem.image = UIImage(systemName: "photo"))
//}

//#Preview {
    // Mock preview item
  //  let previewItem = Item(context: PersistenceController.shared.container.viewContext)
    //previewItem.name = "Test Receipt"
    //previewItem.image = UIImage(systemName: "photo")
//}
