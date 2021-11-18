//
//  MainSceneViewModel.swift
//  MentorMateForsquareApp
//
//  Created by Tornike Gomareli on 16.11.21.
//

import Foundation

struct MainSceneViewModelActions {

}

protocol MainSceneViewModelInput {
    func viewDidLoad()
    func requestFetch(latitude: Double, longitude: Double)
    func requestCachedData()
}

protocol MainSceneViewModelOutput {
    func publishVenues()
}

protocol MainSceneViewModel: MainSceneViewModelInput, MainSceneViewModelOutput {
    var repository: VenuesRepository { get }
    var venuesDataSource: [Venue] { get set }
}

final class DefaultMainSceneViewModel: MainSceneViewModel {
    var repository: VenuesRepository {
        return VenuesRepository()
    }
    
    var venuesDataSource: [Venue] = [Venue]()

    func publishVenues() {
        EventBus.post("fetchVenues", sender: VenuesEvent(venues: self.venuesDataSource, error: false))
    }
}

extension DefaultMainSceneViewModel {
    func viewDidLoad() {
    }
    
    func requestCachedData() {
        repository.requestCachedVenues { cachedVenueResponse in
            self.venuesDataSource = cachedVenueResponse
            self.publishVenues()
        }
    }
    
    func requestFetch(latitude: Double, longitude: Double) {
        repository.requestForFiveVenues(latitude: latitude, longitude: longitude) { venuesResponse in
            self.venuesDataSource = venuesResponse
            self.publishVenues()
        }
    }
}
