//
//  ExpenseDetailView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import SwiftUI

struct ExpenseDetailView: View {
    
    @EnvironmentObject var viewModel: ExpenseDetailViewModel
    
    var body: some View {
        VStack {
            List {
                getHorizontalView(label: "Title",
                                  value: viewModel.title)
                
                getVerticalView(label: "Description",
                                value: viewModel.details)
                
                getHorizontalView(label: "Amount",
                                  value: viewModel.amount)
                
                getHorizontalView(label: "Category",
                                  value: viewModel.category)
                
                getHorizontalView(label: "Type",
                                  value: viewModel.type)
                
                getVerticalView(label: "Creation Date",
                                value: viewModel.creationDate)

                if let paidDateFormatted = viewModel.paidDate {
                    getVerticalView(label: "Paid Date",
                                    value: paidDateFormatted)
                    
                }
                
                Section {
                    Button {
                        viewModel.paidWithdrawButtonPressed()
                    } label: {
                        getPrimaryTextView(label: viewModel.buttonText)
                    }
                }
            }
        }
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
    ExpenseDetailView()
        .environmentObject(ExpenseDetailViewModel(expenseData: ExpenseData.getRandomExpenseData(value: 78, isPaid: true)))
}

#Preview {
    ExpenseDetailView()
        .environmentObject(ExpenseDetailViewModel(expenseData: ExpenseData.getRandomExpenseData(value: 77)))
}
