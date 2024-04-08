//
//  FirebaseManager.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 8/4/24.
//

import Foundation
import FirebaseDatabase

class FirebaseManager: ObservableObject {
    private let database = Database.database().reference()
    
    func saveCategoryData(category: CategoryData) {
        let categoryRef = database.child("categories").child(category.id.uuidString)
        
        let categoryDict: [String: Any] = [
            "title": category.title,
            "isPredefined": category.isPredefined
        ]
        
        categoryRef.setValue(categoryDict)
    }

    func saveExpenseData(expense: ExpenseData) {
        let expenseRef = Database.database().reference().child("expenses").child(expense.id.uuidString)
        
        let expenseDict: [String: Any] = [
            "title": expense.title,
            "details": expense.details,
            "creationDate": expense.creationDate.description,
            "paidDate": expense.paidDate?.description ?? "nil",
            "amount": expense.amount,
            "category": expense.category,
            "type": expense.type
        ]
        
        expenseRef.setValue(expenseDict)
    }
}
