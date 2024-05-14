//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var authManager = AuthenticationManager.shared
    
    var body: some View {
//        if authManager.authenticationState == .authenticated {
            TabContentView()
//        } else {
//            LoginView()
//        }
    }
}

#Preview {
    ContentView()
}
