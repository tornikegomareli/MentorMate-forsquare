//
//  CoreDataRepository.swift
//  MentorMateForsquareApp
//
//  Created by Tornike Gomareli on 18.11.21.
//

import Foundation
import CoreData

/// Enum for CoreData related errors
enum CoreDataError: Error {
    case invalidManagedObjectType
}

class CoreDataRepository: Repository {
    typealias Entity = VenueM
    
    private let managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    
    func get() -> Result<[Entity], Error> {
        let fetchRequest = Entity.fetchRequest()
        do {
            // Perform the fetch request
            if let fetchResults = try managedObjectContext.fetch(fetchRequest) as? [Entity] {
                return .success(fetchResults)
            } else {
                return .failure(CoreDataError.invalidManagedObjectType)
            }
        } catch {
            return .failure(error)
        }
    }
    
    
    func create() -> Result<Entity, Error> {
        let className = String(describing: Entity.self)
        guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: className, into: managedObjectContext) as? Entity else {
            return .failure(CoreDataError.invalidManagedObjectType)
        }
        return .success(managedObject)
    }
    
    func delete(entity: Entity) -> Result<Bool, Error> {
        managedObjectContext.delete(entity)
        return .success(true)
    }
}
