//
//  UserDefaults+Extensions.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/24/24.
//

import Foundation

extension UserDefaults {
    
    func getFavorites() -> [String] {
        
        let favoriteRestaurants = array(forKey: "favorites") as? [String] ?? []
        return favoriteRestaurants
    }
    
    func saveFavorite(restaurant: Restaurant) {
        var favoriteRestaurants = getFavorites()
        favoriteRestaurants.append(restaurant.id)
        set(favoriteRestaurants, forKey: "favorites")
    }
    
    func removeFavorite(restaurant: Restaurant) {
        var favoriteRestaurants = getFavorites()
        favoriteRestaurants.removeAll(where: { $0 == restaurant.id })
        set(favoriteRestaurants, forKey: "favorites")
    }
}
