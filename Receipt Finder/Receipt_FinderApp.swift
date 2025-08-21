//
//  Receipt_FinderApp.swift
//  Receipt Finder
//
//  Created by Rajahiresh Kalva on 7/29/25.
//

import SwiftUI

@main
struct Receipt_FinderApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
    WindowGroup {
        ModeView()
            .environment(\.managedObjectContext,persistenceController.container.viewContext)
        }
    }
}
