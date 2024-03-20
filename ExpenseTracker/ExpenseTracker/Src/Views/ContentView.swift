//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var expenseViewModel: ExpenseViewModel = ExpenseViewModel()
    @StateObject var createExpenseViewModel: CreateExpenseViewModel = CreateExpenseViewModel()
    
    var body: some View {
        TabView(selection: $expenseViewModel.tabSelection) {
            ExpenseView(viewType: .pendingExpenseView,
                        navTitle: "Pending Expense")
                .environmentObject(expenseViewModel)
                .tabItem {
                    Label("Pending Expense", systemImage: "hourglass.circle")
                }
                .tag(ExpenseViewType.pendingExpenseView)
            
            CreateExpenseView()
                .environmentObject(createExpenseViewModel)
                .tabItem {
                    Label("Create New", systemImage: "plus.circle")
                }
                .tag(ExpenseViewType.createNewView)
            
            ExpenseView(viewType: .paidExpenseView,
                        navTitle: "Paid Expense")
                .environmentObject(expenseViewModel)
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
