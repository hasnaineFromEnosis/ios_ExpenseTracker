//
//  ExpenseDetailView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import SwiftUI

struct ExpenseDetailView: View {
    private var expense: Expense
    
    init(expense: Expense) {
        self.expense = expense
    }
    
    var body: some View {
        VStack {
            List {
                getHorizontalView(label: "Title",
                                  value: expense.title)
                
                getVerticalView(label: "Description",
                                value: expense.description)
                
                getHorizontalView(label: "Amount",
                                  value: "\(expense.amount) taka")
                
                getHorizontalView(label: "Category",
                                  value: expense.category)
                
                getHorizontalView(label: "Type",
                                  value: expense.type.rawValue)
                
                getVerticalView(label: "Creation Date",
                                value: formatDate(date: expense.creationDate))

                if let paidDate = expense.paidDate {
                    getVerticalView(label: "Paid Date",
                                    value: formatDate(date: paidDate))
                    
                }
                
                Section {
                    Button {
                        print("yolo")
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
    ExpenseDetailView(expense: Expense.getRandomExpense(value: 78, isPaid: true))
}

#Preview {
    ExpenseDetailView(expense: Expense.getRandomExpense(value: 77))
}
