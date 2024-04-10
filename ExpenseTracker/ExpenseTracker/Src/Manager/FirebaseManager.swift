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
    
    // MARK: - Expense Data Operation
    
    func saveExpenseData(expense: ExpenseData) {
        guard let user = authManager.user else {
            return
        }
        
        let expenseRef = Database.database().reference()
            .child(user.uid)
            .child("expenses")
            .child(expense.id.uuidString)
        
        let expenseDict: [String: Any] = [
            "title": expense.title,
            "details": expense.details,
            "creationDate": expense.creationDate.description,
            "paidDate": expense.paidDate?.description ?? "nil",
            "amount": expense.amount,
            "category": expense.category,
            "type": expense.type,
            "isBaseRecurrent": expense.isBaseRecurrent
        ]
        
        expenseRef.setValue(expenseDict)
    }
    
    func fetchExpenses(completion: @escaping ([ExpenseData], [ExpenseData], [ExpenseData]) -> Void) {
        guard let user = authManager.user else {
            completion([], [], [])
            return
        }
        
        let expensesRef = Database.database().reference().child(user.uid).child("expenses")
        
        expensesRef.observeSingleEvent(of: .value) { snapshot, arg  in
            guard let expensesSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                completion([], [], [])
                return
            }
            
            var paidExpenses: [ExpenseData] = []
            var pendingExpenses: [ExpenseData] = []
            var recurrentExpenses: [ExpenseData] = []
            
            for expenseSnapshot in expensesSnapshot {
                guard let expenseDict = expenseSnapshot.value as? [String: Any] else {
                    continue
                }
                
                let expenseIDString = expenseSnapshot.key
                guard let expenseID = UUID(uuidString: expenseIDString) else {
                    continue
                }
                
                let expense = ExpenseData(id: expenseID,
                                          title: expenseDict["title"] as? String ?? "",
                                          details: expenseDict["details"] as? String ?? "",
                                          amount: expenseDict["amount"] as? Int ?? 0,
                                          category: expenseDict["category"] as? String ?? "",
                                          type: expenseDict["type"] as? String ?? "",
                                          creationDate: (expenseDict["creationDate"] as? String)?.toDate() ?? Date(),
                                          paidDate: (expenseDict["paidDate"] as? String)?.toDate(),
                                          isBaseRecurrent: expenseDict["isBaseRecurrent"] as? Bool ?? false)
                
                if expense.isBaseRecurrent {
                    recurrentExpenses.append(expense)
                } else if expense.paidDate != nil {
                    paidExpenses.append(expense)
                } else {
                    pendingExpenses.append(expense)
                }
            }
            
            completion(pendingExpenses, paidExpenses, recurrentExpenses)
        }
    }
    
    func deleteExpenseData(expense: ExpenseData) {
        guard let user = authManager.user else {
            return
        }
        
        let expenseRef = Database.database().reference()
            .child(user.uid)
            .child("expenses")
            .child(expense.id.uuidString)
        
        expenseRef.removeValue()
    }
}
