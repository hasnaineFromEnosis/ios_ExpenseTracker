//
//  DeletedExpenseData.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 17/5/24.
//

import Foundation

struct DeletedUserData: Identifiable, Hashable {
    var id: UUID
    var creationDate: Date
    var deletedDate: Date
    
    init(id: UUID, creationDate: Date, deletedDate: Date) {
        self.id = id
        self.creationDate = creationDate
        self.deletedDate = deletedDate
    }
    
    init(entity: DeletedUserDataEntity) {
        self.id = entity.id ?? UUID()
        self.creationDate = entity.creationDate ?? Date()
        self.deletedDate = entity.deletedDate ?? Date()
    }
    
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict["id"] = id.uuidString
        dict["creationDate"] = creationDate
        dict["deletedDate"] = deletedDate
        
        return dict
    }
    
    static func fromDict(dict: [String: Any]) -> DeletedUserData? {
        guard let idString = dict["id"] as? String,
              let id = UUID(uuidString: idString),
              let creationDate = dict["creationDate"] as? Date,
              let deletedDate = dict["deletedDate"] as? Date else {
            return nil
        }
        
        return DeletedUserData(id: id, creationDate: creationDate, deletedDate: deletedDate)
    }
}


