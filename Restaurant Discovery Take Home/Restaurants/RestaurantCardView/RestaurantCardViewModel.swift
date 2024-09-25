//
//  RestaurantCardViewModel.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/24/24.
//

import Foundation

class RestaurantCardViewModel: ObservableObject {
    let restaurant: Restaurant
    @Published var isFavorite: Bool
    
    let onFavoriteSelected: (Restaurant) -> Void
    
    init(restaurant: Restaurant, isFavorite: Bool, onFavoriteSelected: @escaping (Restaurant) -> Void) {
        self.restaurant = restaurant
        self.isFavorite = isFavorite
        self.onFavoriteSelected = onFavoriteSelected
    }
}
