//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if AuthenticationManager.shared.authenticationState == .authenticated {
            TabContentView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
