//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var expenseViewModel: ExpenseViewModel = ExpenseViewModel()
    
    var body: some View {
        TabView {
            ExpenseView(viewType: .pendingExpenseView,
                        navTitle: "Pending Expense")
                .environmentObject(expenseViewModel)
                .tabItem {
                    Label("Pending Expense", systemImage: "hourglass.circle")
                }
            
            CreateExpenseView()
                .environmentObject(expenseViewModel)
                .tabItem {
                    Label("Create New", systemImage: "plus.circle")
                }
            
            ExpenseView(viewType: .paidExpenseView,
                        navTitle: "Paid Expense")
                .environmentObject(expenseViewModel)
                .tabItem {
                    Label("Paid Expense", systemImage: "checkmark.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
