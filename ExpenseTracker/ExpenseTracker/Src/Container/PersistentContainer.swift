//
//  PersistentContainer.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import CoreData

class PersistentContainer {
    static let shared = PersistentContainer()
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
    
    func create(title: String, details: String, category: String, amount: Int, type: ExpenseType) {
        let entity = ExpenseData(context: container.viewContext)
        
        entity.id = UUID()
        entity.title = title
        entity.details = details
        entity.category = category
        entity.amount = Int32(amount)
        entity.creationDate = Date()
        entity.type = type.rawValue
        
        saveChanges()
    }
    
    func read(predicateFormat: String? = nil, fetchLimit: Int? = nil) ->[ExpenseData] {
        // For saving fetched notes
        var results: [ExpenseData] = []
        
        // Init fetch request
        let request = NSFetchRequest<ExpenseData>(entityName: "ExpenseData")
        
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
    
    func update(entity: ExpenseData,
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
    
    func delete(entity: ExpenseData) {
        container.viewContext.delete(entity)
        saveChanges()
    }
}

