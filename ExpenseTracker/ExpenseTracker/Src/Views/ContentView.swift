//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView() {
            ExpenseView()
                .environmentObject(ExpenseViewModel(viewType: .pendingExpenseView))
                .tabItem {
                    Label("Pending Expense", systemImage: "hourglass.circle")
                }
                .tag(ExpenseViewType.pendingExpenseView)
            
            ExpenseView()
                .environmentObject(ExpenseViewModel(viewType: .paidExpenseView))
                .tabItem {
                    Label("Paid Expense", systemImage: "checkmark.circle")
                }
                .tag(ExpenseViewType.paidExpenseView)
        }
    }
}

#Preview {
    ContentView()
}
