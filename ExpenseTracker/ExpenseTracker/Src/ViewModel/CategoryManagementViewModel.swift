//
//  CategoryManagementViewModel.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 30/3/24.
//

import SwiftUI
import Combine

class CategoryManagementViewModel: ObservableObject {
    
    private let dataManager = DataManager.shared
    
    @Published var categoryTitle: String = ""
    
    @Published var showCreateCategoryPopup: Bool = false
    
    @Published var showInvalidDataAlert: Bool = false
    @Published var alertTitle: String = "Invalid Name"
    @Published var alertMessage: String = "A category with same name is already exist. Please choose a different name"
    
    var toolbarPlusImageName: String = "plus"
    
    var categoryDataList: [CategoryData] {
        dataManager.categoryList
    }
    
    private var anyCancellable: AnyCancellable? = nil
    
    init() {
        anyCancellable = dataManager.objectWillChange.sink { [weak self] (_) in
                    self?.objectWillChange.send()
                }
    }
    
    func createCategory() {
        for category in categoryDataList {
            if category.title == categoryTitle {
                showInvalidDataAlert = true
                return
            }
        }
      
        let newCategory = CategoryData(title: categoryTitle, 
                                       isPredefined: false,
                                       sourceType: DataSourceType.getCurrentSource(),
                                       creationDate: Date(),
                                       updateDate: Date())
        dataManager.createCategory(categoryData: newCategory)
    }
    
    func deleteCategory(categoryData: CategoryData) {
        var updatedCategoryData = categoryData
        updatedCategoryData.sourceType = DataSourceType.getCurrentSource()
        
        dataManager.deleteCategory(categoryData: updatedCategoryData)
    }
    
    func clearState() {
        categoryTitle = ""
    }
}
