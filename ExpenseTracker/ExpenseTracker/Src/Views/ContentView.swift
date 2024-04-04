//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthenticationViewModel()
    var body: some View {
        LoginView()
            .environmentObject(authViewModel)
    }
}

#Preview {
    ContentView()
}
