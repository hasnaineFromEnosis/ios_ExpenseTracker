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
            let expense: Expense
            = Expense(title: String("Title \(index)"),
                      description: String("Des \(index)"),
                      amount: Int.random(in: 1...100),
                      category: String("Cate \(index)"),
                      type: Expense.ExpenseType.random)
            
            pendingExpenseList.append(expense)
        }
    }
    
    mutating func generatePaidExpense() {
        for index in 1...10{
            let expense: Expense
            = Expense(title: String("Title pending \(index)"),
                      description: String("Des pending \(index)"),
                      amount: Int.random(in: 1...100),
                      category: String("Cate pending \(index)"),
                      type: Expense.ExpenseType.random,
                      date: Date.distantPast
            )
            
            paidExpenseList.append(expense)
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
