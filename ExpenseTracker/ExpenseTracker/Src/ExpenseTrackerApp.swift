//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

#if os(iOS)
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
#endif

@main
struct ExpenseTrackerApp: App {
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    #endif
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
