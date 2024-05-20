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
        entity.sourceType = expenseData.sourceType.rawValue
        entity.updateDate = expenseData.updateDate
        
        saveChanges()
    }
    
    func createCategory(categoryData: CategoryData) {
        let entity = CategoryDataEntity(context: container.viewContext)
        entity.id = categoryData.id
        entity.title = categoryData.title
        entity.isPredefined = categoryData.isPredefined
        entity.sourceType = categoryData.sourceType.rawValue
        entity.creationDate = categoryData.creationDate
        entity.updateDate = categoryData.updateDate
        
        saveChanges()
    }
    
    func createDeletedUserData(userData: DeletedUserData) {
        let entity = DeletedUserDataEntity(context: container.viewContext)
        entity.id = userData.id
        entity.creationDate = userData.creationDate
        entity.deletedDate = userData.deletedDate
        
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
    
    func fetchDeletedUserData(predicateFormat: String? = nil, fetchLimit: Int? = nil) -> [DeletedUserData] {
        var results: [DeletedUserDataEntity] = []
        let request: NSFetchRequest<DeletedUserDataEntity> = DeletedUserDataEntity.fetchRequest()
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
        return convertDeletedUserDataEntityArrayToData(entities: results)
    }
    
    func updateExpense(expenseData: ExpenseData) {
        guard let entity = getExpenseDataEntity(with: expenseData.id) else {
            return
        }
        
        entity.title = expenseData.title
        entity.details = expenseData.details
        entity.category = expenseData.category
        entity.amount = Int32(expenseData.amount)
        entity.type = expenseData.type
        entity.creationDate = expenseData.creationDate
        entity.paidDate = expenseData.paidDate
        entity.sourceType = expenseData.sourceType.rawValue
        entity.updateDate = expenseData.updateDate
        entity.isBaseRecurrent = expenseData.isBaseRecurrent
        
        saveChanges()
    }
    
    func deleteExpense(expenseDataID: UUID) {
        guard let entity = getExpenseDataEntity(with: expenseDataID) else {
            return
        }
        container.viewContext.delete(entity)
        saveChanges()
    }
    
    func deleteCategory(categoryDataID: UUID) {
        guard let entity = getCategoryDataEntity(with: categoryDataID) else {
            return
        }
        container.viewContext.delete(entity)
        saveChanges()
    }
    
    func deleteUserData(userDataID: UUID) {
        guard let entity = getUserDataEntity(with: userDataID) else {
            return
        }
        container.viewContext.delete(entity)
        saveChanges()
    }
    
    func deleteDataFromUserData(id: UUID) {
        self.deleteExpense(expenseDataID: id)
        self.deleteCategory(categoryDataID: id)
    }
    
    // MARK: Private Methods
    private func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
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
    
    private func getExpenseDataEntity(with id: UUID) -> ExpenseDataEntity? {
        let predicate = NSPredicate(format: "id = %@", id as CVarArg)
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
    
    private func getCategoryDataEntity(with id: UUID) -> CategoryDataEntity? {
        let predicate = NSPredicate(format: "id = %@", id as CVarArg)
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
    
    private func getUserDataEntity(with id: UUID) -> DeletedUserDataEntity? {
        let predicate = NSPredicate(format: "id = %@", id as CVarArg)
        let result = self.fetchFirst(DeletedUserDataEntity.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let entity = managedObject {
                return entity
            } else {
                return nil
            }
        case .failure(let error):
            print("Error fetching DeletedUserDataEntity: \(error)")
            return nil
        }
    }
    
    private func convertExpenseEntityArrayToData(entities: [ExpenseDataEntity]) -> [ExpenseData] {
        return entities.map(ExpenseData.init)
    }
    
    private func convertCategoryEntityArrayToData(entities: [CategoryDataEntity]) -> [CategoryData] {
        return entities.map(CategoryData.init)
    }
    
    private func convertDeletedUserDataEntityArrayToData(entities: [DeletedUserDataEntity]) -> [DeletedUserData] {
        return entities.map(DeletedUserData.init)
    }
}
