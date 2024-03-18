//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ExpenseView(color: .red)
                .tabItem {
                    Label("Pending Expense", systemImage: "hourglass.circle")
                }
            
            ExpenseView(color: .green)
                .tabItem {
                    Label("Paid Expense", systemImage: "checkmark.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
