//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab: ExpenseViewType = .pendingExpenseView
    var body: some View {
        TabView(selection: $selectedTab) {
            ExpenseView(viewModel: ExpenseViewModel(viewType: .pendingExpenseView), selectedTab: $selectedTab)
                .tabItem {
                    Label("Pending Expense", systemImage: "hourglass.circle")
                }
                .tag(ExpenseViewType.pendingExpenseView)
            
            ExpenseView(viewModel: ExpenseViewModel(viewType: .paidExpenseView), selectedTab: $selectedTab)
                .tabItem {
                    Label("Paid Expense", systemImage: "checkmark.circle")
                }
                .tag(ExpenseViewType.paidExpenseView)
        }
        .transition(.slide)
    }
}

#Preview {
    ContentView()
}
