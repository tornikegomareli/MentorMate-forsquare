//
//  VenuesEvent.swift
//  MentorMateForsquareApp
//
//  Created by Tornike Gomareli on 16.11.21.
//

import Foundation

class VenuesEvent: NSObject {
    var error: Bool
    var errorMessage: String?
    var venues: [Venue]
    
    init(venues: [Venue], error: Bool, errorMessage: String? = nil) {
        self.errorMessage = errorMessage
        self.error = error
        self.venues = venues
    }
}
