//
//  PersistentStore.swift
//  ExpenseTracker
//
//  Created by Shahwat Hasnaine on 19/3/24.
//

import CoreData

struct PersistentStore {
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
    
    func createExpense(expenseData: ExpenseData) {
        let entity = ExpenseDataEntity(context: container.viewContext)
        entity.id = expenseData.id
        entity.title = expenseData.title
        entity.details = expenseData.details
        entity.category = expenseData.category
        entity.amount = Int32(expenseData.amount)
        entity.creationDate = expenseData.creationDate
        entity.paidDate = expenseData.paidDate
        entity.type = expenseData.type
        entity.isBaseRecurrent = expenseData.isBaseRecurrent
        saveChanges()
    }
    
    func createCategory(categoryData: CategoryData) {
        let entity = CategoryDataEntity(context: container.viewContext)
        entity.id = categoryData.id
        entity.title = categoryData.title
        entity.isPredefined = categoryData.isPredefined
        
        saveChanges()
    }
    
    func fetchExpenses(predicateFormat: String? = nil, fetchLimit: Int? = nil) -> [ExpenseData] {
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
        return convertExpenseEntityArrayToData(entities: results)
    }
    
    func fetchCategory(predicateFormat: String? = nil, fetchLimit: Int? = nil) -> [CategoryData] {
        var results: [CategoryDataEntity] = []
        let request: NSFetchRequest<CategoryDataEntity> = CategoryDataEntity.fetchRequest()
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
        return convertCategoryEntityArrayToData(entities: results)
    }
    
    func updateExpense(expenseData: ExpenseData) {
        guard let entity = getExpenseDataEntity(expenseData: expenseData) else {
            return
        }
        
        entity.title = expenseData.title
        entity.details = expenseData.details
        entity.category = expenseData.category
        entity.amount = Int32(expenseData.amount)
        entity.type = expenseData.type
        entity.creationDate = expenseData.creationDate
        entity.paidDate = expenseData.paidDate
        
        saveChanges()
    }
    
    func deleteExpense(expenseData: ExpenseData) {
        guard let entity = getExpenseDataEntity(expenseData: expenseData) else {
            return
        }
        container.viewContext.delete(entity)
        saveChanges()
    }
    
    func deleteCategory(categoryData: CategoryData) {
        guard let entity = getCategoryDataEntity(categoryData: categoryData) else {
            return
        }
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
    
    private func getExpenseDataEntity(expenseData: ExpenseData) -> ExpenseDataEntity? {
        let predicate = NSPredicate(format: "id = %@", expenseData.id as CVarArg)
        let result = self.fetchFirst(ExpenseDataEntity.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let entity = managedObject {
                return entity
            } else {
                return nil
            }
        case .failure(let error):
            print("Error fetching ExpenseDataEntity: \(error)")
            return nil
        }
    }
    
    private func getCategoryDataEntity(categoryData: CategoryData) -> CategoryDataEntity? {
        let predicate = NSPredicate(format: "id = %@", categoryData.id as CVarArg)
        let result = self.fetchFirst(CategoryDataEntity.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let entity = managedObject {
                return entity
            } else {
                return nil
            }
        case .failure(let error):
            print("Error fetching CategoryDataEntity: \(error)")
            return nil
        }
    }
    
    private func convertExpenseEntityArrayToData(entities: [ExpenseDataEntity]) -> [ExpenseData] {
        return entities.map(ExpenseData.init)
    }
    
    private func convertCategoryEntityArrayToData(entities: [CategoryDataEntity]) -> [CategoryData] {
        return entities.map(CategoryData.init)
    }
}
