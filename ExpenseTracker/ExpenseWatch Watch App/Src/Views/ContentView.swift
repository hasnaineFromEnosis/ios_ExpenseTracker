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
            AddDataView(selectedTab: $selectedTab)
            
            createExpenseView(viewType: .pendingExpenseView)
                .tag(TabViewType.pendingExpenseView)
            
            createExpenseView(viewType: .paidExpenseView)
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
