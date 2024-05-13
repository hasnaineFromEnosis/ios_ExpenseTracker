//
//  ExpenseData.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 25/3/24.
//

import Foundation

struct ExpenseData: Identifiable, Hashable {
    var id: UUID
    var title: String
    var details: String
    var creationDate: Date
    var paidDate: Date?
    var amount: Int
    var category: String
    var type: String
    var sourceType: DataSourceType
    var isBaseRecurrent: Bool
    
    init(id: UUID = UUID(),
         title: String = "Dummy Title",
         details: String = "Dummy Description",
         amount: Int = Int.random(in: 1...1000),
         category: String = "Dummy Category",
         type: String = ExpenseType.random.rawValue,
         sourceType: DataSourceType,
         creationDate: Date = Date.distantPast,
         paidDate: Date? = nil,
         isBaseRecurrent: Bool = false) {
        self.id = id
        self.title = title
        self.details = details
        self.amount = amount
        self.category = category
        self.type = type
        self.sourceType = sourceType
        self.creationDate = creationDate
        self.paidDate = paidDate
        self.isBaseRecurrent = isBaseRecurrent
    }
    
    init(entity: ExpenseDataEntity) {
        self.id = entity.id ?? UUID()
        self.title = entity.title ?? "Untitled"
        self.details = entity.details ?? "Invalid details"
        self.creationDate = entity.creationDate ?? Date()
        self.paidDate = entity.paidDate
        self.amount = Int(entity.amount)
        self.category = entity.category ?? "Invalid category"
        self.type = entity.type ?? ExpenseType.random.rawValue
        self.sourceType = DataSourceType.getTypeFromValue(value: entity.sourceType) ?? DataSourceType.other
        self.isBaseRecurrent = entity.isBaseRecurrent
    }
    
    static func randomExpenseData(isPaid: Bool = false, isRecurrent: Bool = false) -> ExpenseData {
        let type = isRecurrent ? ExpenseType.recurrent : ExpenseType.random
        let paidDate = isPaid ? Date() : nil
        return ExpenseData(type: type.rawValue, sourceType: .other, paidDate: paidDate)
    }
    
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["id"] = id.uuidString
        dict["title"] = title
        dict["details"] = details
        dict["creationDate"] = creationDate
        dict["amount"] = amount
        dict["category"] = category
        dict["type"] = type
        dict["sourceType"] = sourceType.rawValue
        dict["isBaseRecurrent"] = isBaseRecurrent
        
        if let paidDate = paidDate {
            dict["paidDate"] = paidDate
        }
        
        return dict
    }
    
    static func fromDict(dict: [String: Any]) -> ExpenseData? {
        guard let idString = dict["id"] as? String,
              let id = UUID(uuidString: idString),
              let title = dict["title"] as? String,
              let details = dict["details"] as? String,
              let creationDate = dict["creationDate"] as? Date,
              let amount = dict["amount"] as? Int,
              let category = dict["category"] as? String,
              let type = dict["type"] as? String,
              let sourceTypeString = dict["sourceType"] as? String,
              let sourceType = DataSourceType.getTypeFromValue(value: sourceTypeString),
              let isBaseRecurrent = dict["isBaseRecurrent"] as? Bool else {
            return nil
        }
        
        let paidDate = dict["paidDate"] as? Date
        
        return ExpenseData(id: id, title: title, details: details, amount: amount, category: category, type: type, sourceType: sourceType, creationDate: creationDate, paidDate: paidDate, isBaseRecurrent: isBaseRecurrent)
    }
}
