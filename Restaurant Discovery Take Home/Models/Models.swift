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
    let rating: Double
    let displayName: RestaurantDisplayName
}

struct RestaurantDisplayName: Decodable {
    let text: String
}
