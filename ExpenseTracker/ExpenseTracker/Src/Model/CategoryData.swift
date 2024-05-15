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
    var sourceType: DataSourceType
    
    init(id: UUID = UUID(), title: String = "Dummy Title", isPredefined: Bool = false, sourceType: DataSourceType) {
        self.id = id
        self.title = title
        self.isPredefined = isPredefined
        self.sourceType = sourceType
    }
    
    init(entity: CategoryDataEntity) {
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? "Untitled"
        self.isPredefined = entity.isPredefined
        self.sourceType = DataSourceType.getTypeFromValue(value: entity.sourceType) ?? .other
    }
    
    static func randomCategoryData() -> CategoryData {
        return CategoryData(title: "Random Category", sourceType: .other)
    }
    
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["id"] = id.uuidString
        dict["title"] = title
        dict["isPredefined"] = isPredefined
        dict["sourceType"] = sourceType.rawValue
        
        return dict
    }
    
    static func fromDict(dict: [String: Any]) -> CategoryData? {
        guard let idString = dict["id"] as? String,
              let id = UUID(uuidString: idString),
              let title = dict["title"] as? String,
              let isPredefined = dict["isPredefined"] as? Bool,
              let sourceTypeRawValue = dict["sourceType"] as? String,
              let sourceType = DataSourceType(rawValue: sourceTypeRawValue) else {
            return nil
        }
        
        return CategoryData(id: id, title: title, isPredefined: isPredefined, sourceType: sourceType)
    }
}
