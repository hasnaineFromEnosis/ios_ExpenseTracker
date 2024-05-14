//
//  CloudKitRndApp.swift
//  CloudKitRnd
//
//  Created by Shahwat Hasnaine on 11/5/24.
//

import SwiftUI

@main
struct CloudKitRndApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
