//
//  CategoryData.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 31/3/24.
//

import Foundation

struct CategoryData: Identifiable, Hashable {
    var id: UUID
    var title: String
    
    init(id: UUID = UUID(), title: String = "Dummy Title") {
        self.id = id
        self.title = title
    }
    
    init(entity: CategoryDataEntity) {
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? "Untitled"
    }
    
    static func randomCategoryData() -> CategoryData {
        return CategoryData(title: "Random Category")
    }
}
