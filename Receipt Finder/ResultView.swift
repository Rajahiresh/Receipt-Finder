//
//  ResultView.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 7/30/25.
//

import SwiftUI

struct ResultView: View {
    var Names: [String]
    @State var showReceipt: Bool = false
    @State var receiptName: String = ""
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        VStack {
            Text("Receipt Added Successfully!")
                .font(.title)
            List {
                Section("Previous Activity") {
                    ForEach(Names, id: \.self) { index in
                        Button {
                            receiptName = index
                            showReceipt = true
                        } label: {
                            Text(index)
                        }
                    }
                }
            }
        }
        NavigationLink(destination: DetailsView(receiptName: $receiptName, selectedImage: $selectedImage), isActive: $showReceipt)
        {
            EmptyView()
        }
    }
}


#Preview {
    ResultView(Names: ["sample.pdf"],selectedImage: .constant(  UIImage(systemName: "photo")))
}
