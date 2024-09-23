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

struct Restaurant: Identifiable, Decodable {
    let id: String
    let types: [String]
    let formattedAddress: String
    let rating: Double?
    let displayName: RestaurantDisplayName
    let photos: [RestaurantPhotos]?
    
}

struct RestaurantDisplayName: Decodable {
    let text: String
}

struct RestaurantPhotos: Decodable {
    let name: String
    let widthPx: Int
    let heightPx: Int
    
}

struct NearbyRequest: Encodable {
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
