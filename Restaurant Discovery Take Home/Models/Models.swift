//
//  Models.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/20/24.
//

import Foundation

struct RestaurantResponse: Decodable {
    let places: [Restaurant]
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
    
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case formattedAddress
        case rating
        case userRatingCount
        case displayName
        case photos
        case location
        case generativeSummary
    }
    
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        lhs.id == rhs.id
    }
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

