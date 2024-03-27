//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: ExpenseViewType = .pendingExpenseView
    
    var body: some View {
        TabView(selection: $selectedTab) {
            createExpenseView(viewType: .pendingExpenseView)
                .tabItem {
                    Label("Pending Expense", systemImage: "hourglass.circle")
                }
                .tag(ExpenseViewType.pendingExpenseView)
            
            createExpenseView(viewType: .paidExpenseView)
                .tabItem {
                    Label("Paid Expense", systemImage: "checkmark.circle")
                }
                .tag(ExpenseViewType.paidExpenseView)
        }
        .transition(.slide)
    }
    
    private func createExpenseView(viewType: ExpenseViewType) -> some View {
        ExpenseView(viewModel: ExpenseViewModel(viewType: viewType), selectedTab: $selectedTab)
    }
}

#Preview {
    ContentView()
}
