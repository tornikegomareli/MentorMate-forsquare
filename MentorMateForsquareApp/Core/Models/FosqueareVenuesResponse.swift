import Foundation

struct VenueResponse: Codable {
    let response: Response
}

struct Response: Codable {
    let venues: [Venue]
}

struct Venue: Codable {
    let id: String
    let location: Location
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name, location
    }
}


struct Icon: Codable {
    let iconPrefix: String
    let suffix: String

    enum CodingKeys: String, CodingKey {
        case iconPrefix = "prefix"
        case suffix
    }
}

struct Location: Codable {
    let city: String?
    let country: String
}
