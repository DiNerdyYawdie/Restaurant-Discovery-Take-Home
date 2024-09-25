//
//  Models.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/20/24.
//

import Foundation

struct RestaurantResponse: Decodable {
    let places: [Restaurant]?
}

struct Restaurant: Identifiable, Decodable, Equatable {
    let id: String
    let formattedAddress: String
    let rating: Double?
    let userRatingCount: Int?
    let displayName: RestaurantLocalizedText
    let photos: [RestaurantPhotos]?
    let location: RestaurantLocation
    let generativeSummary: RestaurantGenerativeSummary?
    let regularOpeningHours: RegularOpeningHours
    let nationalPhoneNumber: String?
    
    // Additional properites Added
    // Keep track of favorited restaurant
    var isFavorite: Bool = false
    
    // Handle formating of photosURL
    var photoURL: URL? {
            guard let photoReference = photos?.first?.name,
                  let range = photoReference.range(of: "photos/") else {
                return nil
            }

            let photoString = photoReference[range.lowerBound...]
            let urlString = "https://places.googleapis.com/v1/places/\(id)/\(photoString)/media?maxWidthPx=400&key=AIzaSyAvAaPcSL1SNPUguENa_p2P-SuRaxGUduw"
            return URL(string: urlString)
        }
    
    enum CodingKeys: String, CodingKey {
        case id
        case formattedAddress
        case rating
        case userRatingCount
        case displayName
        case photos
        case location
        case generativeSummary
        case regularOpeningHours
        case nationalPhoneNumber
    }
    
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        lhs.id == rhs.id
    }
}

struct RegularOpeningHours: Decodable {
    let openNow: Bool
    let weekdayDescriptions: [String]
}

struct RestaurantLocation: Decodable {
    let latitude: Double
    let longitude: Double
}

struct RestaurantLocalizedText: Decodable {
    let text: String
}

struct RestaurantPhotos: Decodable {
    let name: String
    let widthPx: Int
    let heightPx: Int
}

struct NearbyRequest: Encodable {
    let includedTypes: [String]
    let locationRestriction: LocationRestriction
}

struct LocationRestriction: Encodable {
    let circle: LocationCircle
}

struct LocationCircle: Encodable {
    let center: LocationCircleCoordinates
    let radius: Double
}

struct LocationCircleCoordinates: Encodable {
    let latitude: Double
    let longitude: Double
}

struct RestaurantGenerativeSummary: Decodable {
    let overview: RestaurantLocalizedText?
    let description: RestaurantLocalizedText?
}

