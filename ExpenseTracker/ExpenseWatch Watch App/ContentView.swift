//
//  ContentView.swift
//  ExpenseWatch Watch App
//
//  Created by Shahwat Hasnaine on 6/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: TabViewType = .pendingExpenseView
    
    var body: some View {
        TabView(selection: $selectedTab) {
            createExpenseView(viewType: .pendingExpenseView)
                .tabItem {
                    Label("Pending Expense", systemImage: "hourglass.circle")
                }
                .tag(TabViewType.pendingExpenseView)
            
            createExpenseView(viewType: .paidExpenseView)
                .tabItem {
                    Label("Paid Expense", systemImage: "checkmark.circle")
                }
                .tag(TabViewType.paidExpenseView)
            
        }
        .transition(.slide)
    }
    
    private func createExpenseView(viewType: TabViewType) -> some View {
        ExpenseView(viewModel: ExpenseViewModel(viewType: viewType), selectedTab: $selectedTab)
    }
}

#Preview {
    ContentView()
}
