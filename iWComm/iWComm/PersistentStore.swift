//
//  PersistentStore.swift
//  iWComm
//
//  Created by Shahwat Hasnaine on 10/5/24.
//

import CoreData
import CloudKit

struct PersistentStore {
    let container: NSPersistentCloudKitContainer
    
    private init() {
        container = NSPersistentCloudKitContainer(name: "Model")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Model")
        
//        let storeURL = URL.storeURL(for: "group.hasnaine.WCRnd", databaseName: "Model")
//        let storeDescription = NSPersistentStoreDescription(url: storeURL)
//        container.persistentStoreDescriptions = [storeDescription]
        
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

public extension URL {
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}

