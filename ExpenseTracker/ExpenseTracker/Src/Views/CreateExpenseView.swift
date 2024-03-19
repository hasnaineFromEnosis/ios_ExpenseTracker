//
//  CreateExpenseView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import SwiftUI
import Combine

struct CreateExpenseView: View {
    
    @EnvironmentObject var expenseViewModel: ExpenseViewModel
    
    var body: some View {
        Form {
            Section("Expense Info") {
                TextField("Title", text: $expenseViewModel.expenseTitle)
                TextField("Description", text: $expenseViewModel.expenseDetails)
            }
            
            Section("Category") {
                TextField("Category", text: $expenseViewModel.expenseCategory)
            }
            
            Section("Expense Details") {
                TextField("Amount (in taka)", text: $expenseViewModel.expenseAmount)
                    .keyboardType(.numberPad)
                    .onReceive(Just(expenseViewModel.expenseAmount)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.expenseViewModel.expenseAmount = filtered
                        }
                    }
                Picker("Expense Type", selection: $expenseViewModel.expenseType) {
                    Text(ExpenseType.random.rawValue).tag(ExpenseType.random)
                    Text(ExpenseType.recurrent.rawValue).tag(ExpenseType.recurrent)
                }
            }
            
            Section {
                Button {
                    expenseViewModel.createExpense()
                } label: {
                    Text("Create Expense")
                }
            }
        }
    }
  
}

#Preview {
    CreateExpenseView()
        .environmentObject(ExpenseViewModel())
}
