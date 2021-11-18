//
//  VenueRepository.swift
//  MentorMateForsquareApp
//
//  Created by Tornike Gomareli on 18.11.21.
//

import Foundation
import CoreData

protocol VenueRepositoryInterface {
    func getVenues() -> Result<[Venue], Error>
    func create(venue: Venue) -> Result<Bool, Error>
}

class VenueRepository {
    private let repository: CoreDataRepository
    init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository(managedObjectContext: context)
    }
}

extension VenueRepository: VenueRepositoryInterface {
    @discardableResult func getVenues() -> Result<[Venue], Error> {
        let result = repository.get()
        switch result {
            case .success(let venueM):
                let venues = venueM.map { venueM -> Venue in
                    return venueM.toDomainModel()
                }
                return .success(venues)
            case .failure(let error):
                return .failure(error)
        }
    }
    
    @discardableResult func create(venue: Venue) -> Result<Bool, Error> {
        let result = repository.create()
        switch result {
            case .success(let venueM):
                venueM.country = venue.location.country
                venueM.id = venue.id
                venueM.city = venue.location.city
                venueM.name = venue.name
                return .success(true)
                
            case .failure(let error):
                return .failure(error)
        }
    }
    
}
