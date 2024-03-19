//
//  ExpenseDetailView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import SwiftUI

struct ExpenseDetailView: View {
    private var expense: ExpenseData
    
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    
    init(expense: ExpenseData) {
        self.expense = expense
    }
    
    var body: some View {
        VStack {
            List {
                getHorizontalView(label: "Title",
                                  value: expense.title!)
                
                getVerticalView(label: "Description",
                                value: expense.details!)
                
                getHorizontalView(label: "Amount",
                                  value: "\(expense.amount) taka")
                
                getHorizontalView(label: "Category",
                                  value: expense.category!)
                
                getHorizontalView(label: "Type",
                                  value: expense.type!)
                
                getVerticalView(label: "Creation Date",
                                value: formatDate(date: expense.creationDate!))

                if let paidDate = expense.paidDate {
                    getVerticalView(label: "Paid Date",
                                    value: formatDate(date: paidDate))
                    
                }
                
                Section {
                    Button {
                        expenseViewModel.markAsPaidExpense(expenseData: expense)
                    } label: {
                        getPrimaryTextView(label: expense.isExpensePending()
                                           ? "Pay Expense"
                                           : "Withdraw Expense")
                    }
                }
            }
        }
    }
    
    private func formatDate(date: Date) -> String {
        return date.formatted(date: .complete,
                              time: .standard)
    }
    
    private func getHorizontalView(label: String, value: String) -> some View {
        return HStack {
            getPrimaryTextView(label: label)
            Spacer()
            getSecondaryTextView(label: value)
        }
    }
    
    private func getVerticalView(label: String, value: String) -> some View {
        return VStack(alignment: .leading) {
            getPrimaryTextView(label: label)
            getSecondaryTextView(label: value)
        }
    }
    
    private func getPrimaryTextView(label: String) -> some View {
        return Text(label)
            .fontWeight(.medium)
            .font(.headline)
    }
    
    private func getSecondaryTextView(label: String) -> some View {
        return Text(label)
            .fontWeight(.thin)
            .font(.subheadline)
    }
}

#Preview {
    ExpenseDetailView(expense: Generator.singleExpenseGenerator(value: 78, isPaid: true))
        .environmentObject(ExpenseViewModel())
}

#Preview {
    ExpenseDetailView(expense: Generator.singleExpenseGenerator(value: 77))
        .environmentObject(ExpenseViewModel())
}
