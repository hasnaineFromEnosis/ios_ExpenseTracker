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
    @State var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
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
                        ForEach(ExpenseType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                
                Section {
                    Button {
                        if expenseViewModel.isDataValid() {
                            expenseViewModel.tabSelection = .pendingExpenseView
                            expenseViewModel.createExpense()
                        } else {
                            showAlert = true
                        }
                    } label: {
                        Text("Create Expense")
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Please add data properly"),
                    message: Text("Please ensure that each field is filled out accurately " +
                                  "and provide a standard amount.")
                )
            }
            .navigationTitle("Create Expense")
        }
    }
  
}

#Preview {
    CreateExpenseView()
        .environmentObject(ExpenseViewModel())
}
