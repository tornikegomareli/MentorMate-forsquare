//
//  CoreDataContextProvider.swift
//  MentorMateForsquareApp
//
//  Created by Tornike Gomareli on 18.11.21.
//

import Foundation
import CoreData

class CoreDataContextProvider {
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private var persistentContainer: NSPersistentContainer

    init(completionClosure: ((Error?) -> Void)? = nil) {
        persistentContainer = NSPersistentContainer(name: "MentorMateForsquareApp")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")

            }
            completionClosure?(error)
        }
    }
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}
