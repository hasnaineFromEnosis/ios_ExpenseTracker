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
            if let error {
                fatalError("Could not load Core Data persistence sotres. Error: \(error)")
            }
        }
    }
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ExpenseDataModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error {
                fatalError("Could not load Core Data persistence sotres. Error: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveChanges() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Could not save changes to Core Data. Error: \(error)")
            }
        }
    }
    
    func create(title: String, details: String, category: String, amount: Int, creationDate: Date, paidDate: Date?, type: ExpenseType) -> ExpenseDataEntity {
        let entity = ExpenseDataEntity(context: container.viewContext)
        
        entity.id = UUID()
        entity.title = title
        entity.details = details
        entity.category = category
        entity.amount = Int32(amount)
        entity.creationDate = creationDate
        entity.paidDate = paidDate
        entity.type = type.rawValue
        
        saveChanges()
        
        return entity
    }
    
    func read(predicateFormat: String? = nil, fetchLimit: Int? = nil) ->[ExpenseDataEntity] {
        // For saving fetched notes
        var results: [ExpenseDataEntity] = []
        
        // Init fetch request
        let request = NSFetchRequest<ExpenseDataEntity>(entityName: "ExpenseDataEntity")
        
        // define filter && || limit if needed
        if let predicateFormat {
            request.predicate = NSPredicate(format: predicateFormat)
        }
        
        if let fetchLimit {
            request.fetchLimit = fetchLimit
        }
        
        // Perform fetch with request
        
        do {
            results = try container.viewContext.fetch(request)
        } catch {
            fatalError("Could not fetch notes from Core Data. Error: \(error)")
        }
        
        return results
    }
    
    func update(entity: ExpenseDataEntity,
                title: String? = nil,
                details: String? = nil,
                category: String? = nil, 
                amount: Int? = nil,
                type: ExpenseType? = nil,
                creationDate: Date? = nil,
                paidDate: Date? = nil) {
        var hasChanges: Bool = false
        
        if let title {
            entity.title = title
            hasChanges = true
        }
        
        if let details {
            entity.details = details
            hasChanges = true
        }
        
        if let category {
            entity.category = category
            hasChanges = true
        }
        
        if let amount {
            entity.amount = Int32(amount)
            hasChanges = true
        }
        
        if let type {
            entity.type = type.rawValue
            hasChanges = true
        }
        
        if let creationDate {
            entity.creationDate = creationDate
            hasChanges = true
        }
        
        if let paidDate {
            entity.paidDate = paidDate
            hasChanges = true
        }
        
        if hasChanges {
            saveChanges()
        }
    }
    
    func markExpenseAsPending(entity: ExpenseDataEntity) {
        entity.paidDate = nil
        saveChanges()
    }
    
    func delete(entity: ExpenseDataEntity) {
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