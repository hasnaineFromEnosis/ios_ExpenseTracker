//
//  ExpenseRowView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import SwiftUI

struct ExpenseRowView: View {
    @ObservedObject var viewModel: ExpenseRowViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(viewModel.title)
                    .fontWeight(.medium)
                    .font(.headline)
                
                Text(viewModel.category)
                    .fontWeight(.thin)
                    .font(.caption)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(viewModel.creationDate)
                    .fontWeight(.light)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(viewModel.amount)
                    .fontWeight(.medium)
                    .font(.subheadline)
                    .foregroundStyle(.accent)
                
                if let paidDate = viewModel.paidDate {
                    Text(paidDate)
                        .fontWeight(.light)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    Group {
        ExpenseRowView(viewModel: ExpenseRowViewModel(expenseData: ExpenseData.randomExpenseData()))
        Divider()
        ExpenseRowView(viewModel: ExpenseRowViewModel(expenseData: ExpenseData.randomExpenseData(isPaid: true)))
    }
}

#Preview {
    ExpenseRowView(viewModel: ExpenseRowViewModel(expenseData: ExpenseData.randomExpenseData(isPaid: true)))
}

#Preview {
    ExpenseRowView(viewModel: ExpenseRowViewModel(expenseData: ExpenseData.randomExpenseData()))
}
