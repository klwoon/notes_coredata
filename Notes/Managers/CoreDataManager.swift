//
//  CoreDataManager.swift
//  Notes
//
//  Created by Woon on 27/02/2019.
//  Copyright © 2019 Woon. All rights reserved.
//
import UIKit
import CoreData

final class CoreDataManager {
    
    // MARK: - Properties
    
    private let modelName: String
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        // init managed object context
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        // configure managed object context
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // fetch model url
        guard let url = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to find data model")
        }
        // init managed object model
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("unable to load data model")
        }
        return model
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // init persistent store coordinator
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        // helpers
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        // url documents directory
        let directoryUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // url persistent store
        let storeUrl = directoryUrl.appendingPathComponent(storeName)
        
        do {
            // add persistent store
            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                           NSInferMappingModelAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: storeUrl,
                                               options: options)
        } catch {
            fatalError("unable to add persistent store")
        }
        return coordinator
    }()
    
    // MARK: - Initialization
    
    init(modelName: String) {
        self.modelName = modelName
        setupNotificationHandling()
    }
    
    private func setupNotificationHandling() {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(saveChanges(_:)),
                           name: UIApplication.willTerminateNotification,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(saveChanges(_:)),
                           name: UIApplication.didEnterBackgroundNotification,
                           object: nil)
    }
    
    @objc func saveChanges(_ notification: Notification) {
        saveChanges()
    }
    
    private func saveChanges() {
        guard managedObjectContext.hasChanges else { return }
        do {
            try managedObjectContext.save()
        } catch {
            print("Unable to Save Managed Object Context")
            print("\(error), \(error.localizedDescription)")
        }
    }
}
