//
//  PersistentStore.swift
//  iWComm
//
//  Created by Shahwat Hasnaine on 10/5/24.
//

import CoreData

struct PersistentStore {
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        
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
    
    func createExpense() {
        let entity = TestModel(context: container.viewContext)
        entity.counter = Int32.random(in: 1...10)
        entity.name = "Hash9 \(Int.random(in: 1...10))"
        saveChanges()
    }
    
    func fetchExpenses(predicateFormat: String? = nil, fetchLimit: Int? = nil) -> [TestModel] {
        var results: [TestModel] = []
        let request: NSFetchRequest<TestModel> = TestModel.fetchRequest()
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
    
    func deleteExpense(testData: TestModel) {
        container.viewContext.delete(testData)
        saveChanges()
    }
}

