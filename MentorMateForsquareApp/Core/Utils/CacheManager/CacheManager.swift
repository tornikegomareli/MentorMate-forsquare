//
//  CacheManager.swift
//  MentorMateForsquareApp
//
//  Created by Tornike Gomareli on 18.11.21.
//

import Foundation

class CacheManager {
    private init() {}
    class func shared() -> CacheManager {
        return CacheManager()
    }
    
    func getVenuesFromCacheIfNeeded() -> [Venue] {
        let dbContext = CoreDataContextProvider { _ in  }
        
        let unitOfWork = UnitOfWork(context: dbContext.viewContext)
        let result = unitOfWork.venuesRepository.getVenues()
        
        switch result {
            case .success(let venues):
                return venues
            case .failure(let error):
                print(error)
                return [Venue]()
        }
    }
    
    func cacheVenues(venues: [Venue]) {
        let dbContext = CoreDataContextProvider { _ in }
        let unitOfWork = UnitOfWork(context: dbContext.viewContext)
        venues.forEach { venue in
            unitOfWork.venuesRepository.create(venue: venue)
            unitOfWork.saveChanges()
        }
    }
}
