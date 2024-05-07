//
//  AddCategoryViewModel.swift
//  ExpenseWatch Watch App
//
//  Created by Shahwat Hasnaine on 7/5/24.
//

import SwiftUI

class AddCategoryViewModel: ObservableObject {
    private let dataManager = DataManager.shared
    
    @Published var categoryTitle: String = ""
    
    @Published var showInvalidDataAlert: Bool = false
    @Published var alertTitle: String = "Invalid Name"
    @Published var alertMessage: String = "A category with same name is already exist. Please choose a different name"
    
    var toolbarPlusImageName: String = "plus"
    
    var categoryDataList: [CategoryData] {
        dataManager.categoryList
    }
    
    func createCategory() -> Bool {
        for category in categoryDataList {
            if category.title == categoryTitle {
                showInvalidDataAlert = true
                return false
            }
        }
        
        let newCategory = CategoryData(title: categoryTitle, isPredefined: false)
        dataManager.createCategory(categoryData: newCategory)
        
        return true
    }
    
    func deleteCategory(categoryData: CategoryData) {
        dataManager.deleteCategory(categoryData: categoryData)
    }
    
    func clearState() {
        categoryTitle = ""
    }
}


