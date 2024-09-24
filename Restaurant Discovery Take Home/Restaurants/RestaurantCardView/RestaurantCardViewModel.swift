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
    
    // TODO: Fix construct of image URL
    func createRestaurantPhotoURL() -> URL? {
        
        if let photoReference = restaurant.photos?.first?.name {
            if let range = photoReference.range(of: "photos/") {
                // Extract the substring from "photos/" to the end
                let photoString = photoReference[range.lowerBound...]
                print(photoString)
                
                let urlString = "https://places.googleapis.com/v1/places/\(restaurant.id)/\(photoString)/media?maxWidthPx=400&key=AIzaSyAvAaPcSL1SNPUguENa_p2P-SuRaxGUduw"
                return URL(string: urlString)
            } else {
                return nil
            }
        } else {
            return nil
        }
        
    }
}
