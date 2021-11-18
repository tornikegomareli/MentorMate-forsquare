//
//  VenuesRepositor.swift
//  MentorMateForsquareApp
//
//  Created by Tornike Gomareli on 11.11.21.
//

import Foundation

typealias CompletionHandler = ([Venue]) -> Void

protocol VenuesRepositoring {
    func requestForFiveVenues(latitude: Double, longitude: Double, handler: @escaping CompletionHandler)
}

class VenuesRepository: VenuesRepositoring {
    let vanuesRateLimit = 5
    
    func requestCachedVenues(handler: @escaping ([Venue]) -> Void) {
        let cachedVenues = CacheManager.shared().getVenuesFromCacheIfNeeded()
        if cachedVenues.count != 0 {
            handler(cachedVenues)
        }
    }

    func requestForFiveVenues(latitude: Double, longitude: Double, handler: @escaping ([Venue]) -> Void) {
        let clientId = Bundle.main.getConfig(key: .clientId, orDefault: "")
        let clientSecret = Bundle.main.getConfig(key: .clientSecret, orDefault: "")
        let client = FoursquareAPIClient(clientId: clientId, clientSecret: clientSecret)
        
        let parameter: [String: String] = [
            "ll": "\(latitude),\(longitude)",
            "limit": "\(vanuesRateLimit)",
        ];
        
        client.request(path: "venues/search", parameter: parameter) { result in
            switch result {
                case let .success(data):
                    print(data.prettyPrintedJSONString)
                    var model = try! JSONDecoder().decode(VenueResponse.self, from: data)
                    handler(model.response.venues)
                    CacheManager.shared().cacheVenues(venues: model.response.venues)
                case let .failure(error):
                    switch error {
                        case let .connectionError(connectionError):
                            print(connectionError)
                        case let .responseParseError(responseParseError):
                            print(responseParseError)
                        case let .apiError(apiError):
                            print(apiError.errorType)
                            print(apiError.errorDetail)
                    }
            }
        }
    }
}


extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
