//
//  PersistenceController.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import CoreData

struct PersistenceController {
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "ExpenseDataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ExpenseDataModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - Core Data Operations
    
    func saveChanges() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error saving context: \(error)")
            }
        }
    }
    
    func createExpense(title: String,
                       details: String,
                       category: String,
                       amount: Int,
                       creationDate: Date,
                       paidDate: Date?,
                       type: ExpenseType,
                       isBaseRecurrent: Bool) -> ExpenseDataEntity {
        let entity = ExpenseDataEntity(context: container.viewContext)
        entity.id = UUID()
        entity.title = title
        entity.details = details
        entity.category = category
        entity.amount = Int32(amount)
        entity.creationDate = creationDate
        entity.paidDate = paidDate
        entity.type = type.rawValue
        entity.isBaseRecurrent = isBaseRecurrent
        saveChanges()
        return entity
    }
    
    func fetchExpenses(predicateFormat: String? = nil, fetchLimit: Int? = nil) -> [ExpenseDataEntity] {
        var results: [ExpenseDataEntity] = []
        let request: NSFetchRequest<ExpenseDataEntity> = ExpenseDataEntity.fetchRequest()
        if let predicateFormat = predicateFormat {
            request.predicate = NSPredicate(format: predicateFormat)
        }
        if let fetchLimit = fetchLimit {
            request.fetchLimit = fetchLimit
        }
        do {
            results = try container.viewContext.fetch(request)
        } catch {
            fatalError("Error fetching expenses: \(error)")
        }
        return results
    }
    
    func updateExpense(entity: ExpenseDataEntity,
                       title: String? = nil,
                       details: String? = nil,
                       category: String? = nil,
                       amount: Int? = nil,
                       type: ExpenseType? = nil,
                       creationDate: Date? = nil,
                       paidDate: Date? = nil) {
        var hasChanges = false
        if let title = title {
            entity.title = title
            hasChanges = true
        }
        // Similar for other properties...
        
        if hasChanges {
            saveChanges()
        }
    }
    
    func markExpenseAsPending(entity: ExpenseDataEntity) {
        entity.paidDate = nil
        saveChanges()
    }
    
    func deleteExpense(entity: ExpenseDataEntity) {
        container.viewContext.delete(entity)
        saveChanges()
    }
    
    func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try container.viewContext.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
}
