//
//  DomainModel.swift
//  MentorMateForsquareApp
//
//  Created by Tornike Gomareli on 18.11.21.
//

import Foundation

protocol DomainModel {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
}

extension VenueM: DomainModel {
    func toDomainModel() -> Venue {
        return Venue(id: self.id!, location: Location(city: self.city, country: self.country!), name: self.name!)
    }
}
