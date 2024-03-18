//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 18/3/24.
//

import SwiftUI

struct ContentView: View {
    var pendingExpenseList: [Expense] = []
    var paidExpenseList: [Expense] = []
    
    mutating func generatePendingExpense() {
        for index in 1...10{
            pendingExpenseList.append(Expense.getRandomExpense(value: index))
        }
    }
    
    mutating func generatePaidExpense() {
        for index in 1...10{
            pendingExpenseList.append(Expense.getRandomExpense(value: index, isPaid: true))
        }
    }
    
    init() {
        generatePaidExpense()
        generatePendingExpense()
    }
    
    var body: some View {
        TabView {
            ExpenseView(color: .red, expenses: self.pendingExpenseList)
                .tabItem {
                    Label("Pending Expense", systemImage: "hourglass.circle")
                }
            
            ExpenseView(color: .green, expenses: self.paidExpenseList)
                .tabItem {
                    Label("Paid Expense", systemImage: "checkmark.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
