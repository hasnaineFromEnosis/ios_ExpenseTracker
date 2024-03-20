//
//  CreateExpenseView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import SwiftUI
import Combine

struct CreateExpenseView: View {
    
    @EnvironmentObject var viewModel: CreateExpenseViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Expense Info") {
                    TextField("Title", text: $viewModel.expenseTitle)
                    TextField("Description", text: $viewModel.expenseDetails)
                }
                
                Section("Category") {
                    TextField("Category", text: $viewModel.expenseCategory)
                }
                
                Section("Expense Details") {
                    TextField("Amount (in taka)", text: $viewModel.expenseAmount)
                        .keyboardType(.numberPad)
                        .onReceive(Just(viewModel.expenseAmount)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.viewModel.expenseAmount = filtered
                            }
                        }
                    Picker("Expense Type", selection: $viewModel.expenseType) {
                        ForEach(ExpenseType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                
                Section {
                    Button {
                        if viewModel.validateData() {
                            dismiss()
                        }
                    } label: {
                        Text(viewModel.createExpenseButtonText)
                    }
                }
            }
            .alert(isPresented: $viewModel.showInvalidDataAlert) {
                Alert(
                    title: Text(viewModel.alertTitle),
                    message: Text(viewModel.alertMessage)
                )
            }
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle(viewModel.navigationTitle)
        }
    }
}

#Preview {
    CreateExpenseView()
        .environmentObject(CreateExpenseViewModel())
}
