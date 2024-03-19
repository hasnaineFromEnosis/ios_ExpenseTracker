//
//  ExpenseRowView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import SwiftUI

struct ExpenseRowView: View {
    private var expense: ExpenseData
    
    init(expense: ExpenseData) {
        self.expense = expense
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(expense.title!)
                    .fontWeight(.medium)
                    .font(.headline)
                
                Text(expense.category!)
                    .fontWeight(.thin)
                    .font(.caption)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(formatDate(date: expense.creationDate!))
                    .fontWeight(.light)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("\(expense.amount) taka")
                    .fontWeight(.medium)
                    .font(.subheadline)
                    .foregroundStyle(.accent)
                
                if let paidDate = expense.paidDate {
                    Text(formatDate(date: paidDate))
                        .fontWeight(.light)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    func formatDate(date: Date) -> String {
        return date.formatted(date: Date.FormatStyle.DateStyle.abbreviated, time: .omitted)
    }
}

#Preview {
    Group {
        ExpenseRowView(expense: ExpenseData.getRandomExpenseData(value: 5))
        Divider()
        ExpenseRowView(expense: ExpenseData.getRandomExpenseData(value: 6, isPaid: true))
    }
}

#Preview {
    ExpenseRowView(expense: ExpenseData.getRandomExpenseData(value: 2, isPaid: true))
}

#Preview {
    ExpenseRowView(expense: ExpenseData.getRandomExpenseData(value: 4))
}
