//
//  CloudKitRnd2App.swift
//  CloudKitRnd2
//
//  Created by Shahwat Hasnaine on 12/5/24.
//

import SwiftUI

@main
struct CloudKitRnd2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
