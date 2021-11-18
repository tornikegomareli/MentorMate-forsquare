//
//  UnitOfWork.swift
//  MentorMateForsquareApp
//
//  Created by Tornike Gomareli on 18.11.21.
//

import Foundation
import CoreData

class UnitOfWork {
    private let context: NSManagedObjectContext

    let venuesRepository: VenueRepository

    init(context: NSManagedObjectContext) {
        self.context = context
        self.venuesRepository = VenueRepository(context: context)
    }

    @discardableResult func saveChanges() -> Result<Bool, Error> {
        do {
            try context.save()
            return .success(true)
        } catch {
            context.rollback()
            return .failure(error)
        }
    }
}
