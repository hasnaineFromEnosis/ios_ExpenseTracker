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
    var isPredefined: Bool
    
    init(id: UUID = UUID(), title: String = "Dummy Title", isPredefined: Bool = false) {
        self.id = id
        self.title = title
        self.isPredefined = isPredefined
    }
    
    init(entity: CategoryDataEntity) {
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? "Untitled"
        self.isPredefined = entity.isPredefined
    }
    
    static func randomCategoryData() -> CategoryData {
        return CategoryData(title: "Random Category")
    }
}
