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
    private let authManager = AuthenticationManager.shared
    
    // MARK: - Category Data Operation
    
    func saveCategoryData(category: CategoryData) {
        guard let user = authManager.user else {
            return
        }
        
        let categoryRef = Database.database().reference()
            .child(user.uid)
            .child("categories")
            .child(category.id.uuidString)
        
        let categoryDict: [String: Any] = [
            "title": category.title,
            "isPredefined": category.isPredefined
        ]
        
        categoryRef.setValue(categoryDict)
    }

    func fetchCategories(completion: @escaping ([CategoryData]) -> Void) {
        guard let user = authManager.user else {
            completion([])
            return
        }
        
        let categoriesRef = Database.database().reference()
            .child(user.uid)
            .child("categories")
        
        categoriesRef.observeSingleEvent(of: .value) { snapshot in
            var categories: [CategoryData] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let categoryDict = snapshot.value as? [String: Any],
                   let title = categoryDict["title"] as? String,
                   let isPredefined = categoryDict["isPredefined"] as? Bool,
                   let id = UUID(uuidString: snapshot.key) {
                    
                    let category = CategoryData(id: id, title: title, isPredefined: isPredefined)
                    categories.append(category)
                }
            }
            
            completion(categories)
        }
    }
    
    func deleteCategoryData(category: CategoryData) {
        guard let user = authManager.user else {
            return
        }
        
        let categoryRef = Database.database().reference()
            .child(user.uid)
            .child("categories")
            .child(category.id.uuidString)
        
        categoryRef.removeValue()
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
