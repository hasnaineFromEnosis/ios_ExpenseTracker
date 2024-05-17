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
    var creationDate: Date
    var updateDate: Date
    
    init(id: UUID = UUID(), title: String = "Dummy Title", isPredefined: Bool = false, sourceType: DataSourceType, creationDate: Date, updateDate: Date) {
        self.id = id
        self.title = title
        self.isPredefined = isPredefined
        self.sourceType = sourceType
        self.creationDate = creationDate
        self.updateDate = updateDate
    }
    
    init(entity: CategoryDataEntity) {
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? "Untitled"
        self.isPredefined = entity.isPredefined
        self.sourceType = DataSourceType.getTypeFromValue(value: entity.sourceType) ?? .other
        self.creationDate = entity.creationDate ?? Date()
        self.updateDate = entity.updateDate ?? Date()
    }
    
    static func randomCategoryData() -> CategoryData {
        return CategoryData(title: "Random Category", sourceType: .other, creationDate: Date(), updateDate: Date())
    }
    
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["id"] = id.uuidString
        dict["title"] = title
        dict["isPredefined"] = isPredefined
        dict["sourceType"] = sourceType.rawValue
        dict["creationDate"] = creationDate
        dict["updateDate"] = updateDate
        
        return dict
    }
    
    static func fromDict(dict: [String: Any]) -> CategoryData? {
        guard let idString = dict["id"] as? String,
              let id = UUID(uuidString: idString),
              let title = dict["title"] as? String,
              let isPredefined = dict["isPredefined"] as? Bool,
              let creationDate = dict["creationDate"] as? Date,
              let updateDate = dict["updateDate"] as? Date,
              let sourceTypeRawValue = dict["sourceType"] as? String,
              let sourceType = DataSourceType(rawValue: sourceTypeRawValue) else {
            return nil
        }
        
        return CategoryData(id: id, title: title, isPredefined: isPredefined, sourceType: sourceType, creationDate: creationDate, updateDate: updateDate)
    }
}
