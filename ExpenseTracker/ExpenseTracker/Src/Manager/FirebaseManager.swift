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
        // Create a reference to a child node in the database (e.g., "categories")
        let categoryRef = database.child("categories").child(category.id.uuidString)
        
        // Convert CategoryData object to a dictionary
        let categoryDict: [String: Any] = [
            "title": category.title,
            "isPredefined": category.isPredefined
        ]
        
        // Save the data to Firebase
        categoryRef.setValue(categoryDict)
    }

}
