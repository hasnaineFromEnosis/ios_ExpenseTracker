//
//  CreateExpenseView.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import SwiftUI
import Combine

struct CreateExpenseView: View {
    
    @State var title: String = ""
    @State var description: String = ""
    @State var category: String = ""
    
    @State var amount: String = ""
    @State var type: ExpenseType = .random
    
    var body: some View {
        Form {
            Section("Expense Info") {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
            }
            
            Section("Category") {
                TextField("Category", text: $category)
            }
            
            Section("Expense Details") {
                TextField("Amount (in taka)", text: $amount)
                    .keyboardType(.numberPad)
                    .onReceive(Just(amount)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.amount = filtered
                        }
                    }
                Picker("Expense Type", selection: $type) {
                    Text(ExpenseType.random.rawValue)
                    Text(ExpenseType.recurrent.rawValue)
                }
            }
            
            Section {
                Button {
                    
                } label: {
                    Text("Create Expense")
                }
            }
        }
    }
  
}

#Preview {
    CreateExpenseView()
}
