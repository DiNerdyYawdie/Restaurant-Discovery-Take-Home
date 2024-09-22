//
//  RestaurantsViewModel.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/20/24.
//

import Foundation

class RestaurantsViewModel: ObservableObject {
    
    @Published var restaurants: [Restaurant] = []
    @Published var searchText: String = ""
    
    @Published var showMapView: Bool = false
    
    @Published var isLoading: Bool = false
    
    let restaurantServices: RestaurantServices
    
    init(restaurantServices: RestaurantServices) {
        self.restaurantServices = restaurantServices
    }
    
    @MainActor
    func fetchRestaurants() async {
        do {
            isLoading = true
            self.restaurants = try await restaurantServices.searchRestaurants(with: searchText)
            isLoading = false
        } catch {
            isLoading = false
            print(error)
        }
    }
}
