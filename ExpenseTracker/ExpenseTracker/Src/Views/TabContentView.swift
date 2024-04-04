//
//  TabContentView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 5/4/24.
//

import SwiftUI

enum TabViewType {
    case pendingExpenseView
    case paidExpenseView
    case settingsView
    case trendyView
}

struct TabContentView: View {
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
            
            TrendView()
                .tabItem {
                    Label("Trend", systemImage: "chart.line.uptrend.xyaxis.circle")
                }
                .tag(TabViewType.trendyView)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(TabViewType.settingsView)
        }
        .transition(.slide)
    }
    
    private func createExpenseView(viewType: TabViewType) -> some View {
        ExpenseView(viewModel: ExpenseViewModel(viewType: viewType), selectedTab: $selectedTab)
    }
}

#Preview {
    TabContentView()
}
